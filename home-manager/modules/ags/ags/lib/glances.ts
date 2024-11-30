import { Variable } from "astal";

function glancesLineToParseableJson(inputStr: string) {
    const match = inputStr.match(/^(\w+): (.*)$/);
    if (match) {
        const key = match[1];
        const jsonString = match[2].trim();
        try {
            const jsonObject = JSON.parse(jsonString);
            return JSON.stringify({ [key]: jsonObject });
        } catch (e) {
            throw new Error(`Invalid JSON string: ${jsonString}`);
        }
    } else {
        throw new Error("Invalid input string");
    }
}

export type GlancesCpuStat = {
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
): Variable<GlancesCpuStat> | Variable<GlancesMemoryStat> | Variable<{}> {
    return Variable({}).watch(
        `glances --stdout-json ${process} --time 1`,
        (stdout: string) => {
            return JSON.parse(glancesLineToParseableJson(stdout));
        },
    );
}
