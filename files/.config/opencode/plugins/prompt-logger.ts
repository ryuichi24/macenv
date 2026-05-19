import * as fs from "fs";
import * as path from "path";

import type { Plugin } from "@opencode-ai/plugin";

export const PromptLoggerPlugin: Plugin = async (ctx) => {
  return {
    "experimental.chat.messages.transform": async (input, output) => {
      return;
      console.log("=== FINAL PROMPT TO LLM ===");
      console.log(JSON.stringify(output.messages, null, 2));
      const outputFileUniqueId = Math.random().toString(36).substring(2, 15);
      const filePath = path.join(
        process.cwd(),
        "output",
        `prompt.${outputFileUniqueId}.json`,
      );
      if (!fs.existsSync(path.dirname(filePath))) {
        fs.mkdirSync(path.dirname(filePath), { recursive: true });
      }
      fs.writeFileSync(filePath, JSON.stringify(output.messages, null, 2));
      console.log("=== END PROMPT ===");
    },
  };
};
