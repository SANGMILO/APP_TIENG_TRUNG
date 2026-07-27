import { stitch } from "@google/stitch-sdk";
import fs from "node:fs/promises";
import path from "node:path";

const PROJECT_ID = "6506278782152367391";
const OUTPUT_DIR = path.resolve("stitch-reference");

async function download(url, outputPath, binary = false) {
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error(
      `Download failed ${response.status} ${response.statusText}: ${url}`
    );
  }

  if (binary) {
    const data = Buffer.from(await response.arrayBuffer());
    await fs.writeFile(outputPath, data);
  } else {
    const text = await response.text();
    await fs.writeFile(outputPath, text, "utf8");
  }
}

async function main() {
  if (!process.env.STITCH_API_KEY) {
    throw new Error(
      "STITCH_API_KEY is missing. Set it in PowerShell before running."
    );
  }

  await fs.mkdir(OUTPUT_DIR, { recursive: true });

  console.log(`Reading Stitch project ${PROJECT_ID}...`);

  const project = stitch.project(PROJECT_ID);
  const screens = await project.screens();

  console.log(`Found ${screens.length} screens.`);

  const manifest = {
    projectId: PROJECT_ID,
    exportedAt: new Date().toISOString(),
    screens: [],
  };

  for (let i = 0; i < screens.length; i++) {
    const screen = screens[i];
    const number = String(i + 1).padStart(2, "0");
    const folderName = `${number}_${screen.screenId}`;
    const screenDir = path.join(OUTPUT_DIR, folderName);

    await fs.mkdir(screenDir, { recursive: true });

    console.log(
      `[${i + 1}/${screens.length}] Exporting ${screen.screenId}...`
    );

    try {
      const [htmlUrl, imageUrl] = await Promise.all([
        screen.getHtml(),
        screen.getImage(),
      ]);

      const htmlPath = path.join(screenDir, "design.html");
      const imagePath = path.join(screenDir, "screenshot.png");

      await Promise.all([
        download(htmlUrl, htmlPath, false),
        download(imageUrl, imagePath, true),
      ]);

      manifest.screens.push({
        index: i + 1,
        screenId: screen.screenId,
        folder: folderName,
        html: `${folderName}/design.html`,
        image: `${folderName}/screenshot.png`,
        status: "ok",
      });

      console.log(`  OK -> ${folderName}`);
    } catch (error) {
      console.error(`  FAILED -> ${screen.screenId}`);
      console.error(`  ${error.message}`);

      manifest.screens.push({
        index: i + 1,
        screenId: screen.screenId,
        folder: folderName,
        status: "failed",
        error: error.message,
      });
    }
  }

  await fs.writeFile(
    path.join(OUTPUT_DIR, "manifest.json"),
    JSON.stringify(manifest, null, 2),
    "utf8"
  );

  console.log("");
  console.log("================================");
  console.log("STITCH EXPORT COMPLETE");
  console.log(`Screens: ${screens.length}`);
  console.log(`Output : ${OUTPUT_DIR}`);
  console.log("================================");
}

main().catch((error) => {
  console.error("\nEXPORT FAILED");
  console.error(error);
  process.exit(1);
});