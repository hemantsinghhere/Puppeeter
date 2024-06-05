const express = require("express");
const puppeteer = require("puppeteer");
// const fs = require("fs");
// const path = require("path");

const app = express();
const port = 3000;

app.get("/", async (req, res) => {
  try {
    console.log("Launching browser");
    const browser = await puppeteer.launch({
      headless: true,
      args: [
        "--no-sandbox",
        // "--headless",
        // "--disable-gpu",
        // "--disable-dev-shm-usage",
        "--single-process",
        // "--disable-extensions",
        "--no-zygote",
      ],
      executablePath: process.env.NODE_ENV === "production" ? process_env_PUPPETEER_EXECUTABLE_PATH : puppeteer.executablePath(),
      
    });

    console.log("Opening new page");
    const page = await browser.newPage();

    // Set the HTML content you want to convert to PDF
    const htmlContent = `
      <html>
        <head>
          <title>Generated PDF</title>
        </head>
        <body>
          <h1>Hello, World!</h1>
          <p>This is a PDF generated by an API using Puppeteer.</p>
        </body>
      </html>
    `;

    console.log("Setting HTML content");
    await page.setContent(htmlContent);

    console.log("Generating PDF");
    const pdfBuffer = await page.pdf({ format: "A4", timeout: 90000 });

    console.log("Closing browser");
    await browser.close();

    // Set the header for the PDF download
    res.setHeader("Content-Type", "application/pdf");
    res.setHeader("Content-Disposition", "inline; filename=output.pdf");

    // Send the PDF buffer as a response
    console.log("Sending PDF response");
    res.send(pdfBuffer);
  } catch (error) {
    console.error("Error generating PDF:", error);
    res.status(500).send("Error generating PDF!!! " + error);
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
