import { Accessor } from "ags";
import { createSubprocess } from "ags/process";

function parsePythonBytesJson(pythonStr: string) {
  // First, validate that the input starts with b' or b"
  if (!pythonStr.startsWith("b'") && !pythonStr.startsWith('b"')) {
    throw new Error("Input must start with b' or b\"");
  }

  // Remove the 'b' prefix and the surrounding quotes
  // We need to handle both single and double quotes
  let jsonStr = pythonStr.slice(2, -1);

  // If the string contains escaped characters, we need to properly handle them
  jsonStr = jsonStr
    .replace(/\\'/g, "'") // Handle escaped single quotes
    .replace(/\\"/g, '"') // Handle escaped double quotes
    .replace(/\\n/g, "\n"); // Handle newlines if present

  try {
    // Parse the resulting string as JSON
    return JSON.parse(jsonStr);
  } catch (error: any) {
    throw new Error(`Failed to parse JSON: ${error.message}`);
  }
}

function glancesLineToParseableJson(inputStr: string) {
  const match = inputStr.match(/^(\w+): (.*)$/);
  if (match) {
    const key = match[1];
    const jsonString = match[2].trim();
    try {
      const jsonObject = parsePythonBytesJson(jsonString);
      return JSON.stringify({ [key]: jsonObject });
    } catch (e) {
      throw new Error(`Invalid JSON string: ${jsonString}`);
    }
  } else {
    throw new Error("Invalid input string");
  }
}

export type GlancesPerCpuStat = {
  percpu: Array<{
    key: string;
    cpu_number: number;
    total: number;
    user: number;
    system: number;
    idle: number;
    nice: number;
    iowait: number;
    irq: number;
    softirq: number;
    steal: number;
    guest: number;
    guest_nice: number;
  }>;
};

export type GlancesCpuStat = {
  cpu: {
    total: number;
    user: number;
    nice: number;
    system: number;
    idle: number;
    iowait: number;
    irq: number;
    steal: number;
    guest: number;
    ctx_switches: number;
    interrupts: number;
    soft_interrupts: number;
    syscalls: number;
    cpucore: number;
  };
};

export type GlancesMemoryStat = {
  mem: {
    total: number;
    available: number;
    percent: number;
    used: number;
    free: number;
    active: number;
    inactive: number;
    buffers: number;
    cached: number;
    shared: number;
  };
};

export type GlancesNetworkStat = {
  network: Array<{
    bytes_sent: number;
    bytes_recv: number;
    speed: number;
    key: string;
    interface_name: string;
    alias: string;
    bytes_all: number;
    time_since_update: number;
    bytes_recv_gauge: number;
    bytes_recv_rate_per_sec: number;
    bytes_sent_gauge: number;
    bytes_sent_rate_per_sec: number;
    bytes_all_gauge: number;
    bytes_all_rate_per_sec: number;
  }>;
};

export function bytesToHumanReadable(bytes: number): string {
  const units = ["B", "KB", "MB", "GB", "TB", "PB"];
  let i = 0;
  while (bytes >= 1024 && i < units.length - 1) {
    bytes /= 1024;
    i++;
  }
  return bytes.toFixed(2) + " " + units[i];
}

export function glancesToJSON(
  process: string,
):
  | Accessor<GlancesPerCpuStat>
  | Accessor<GlancesMemoryStat>
  | Accessor<GlancesNetworkStat>
  | Accessor<{}> {
  return createSubprocess(
    {},
    `glances --stdout-json ${process} --time 1`,
    (stdout: string) => {
      return JSON.parse(glancesLineToParseableJson(stdout));
    },
  );
}
