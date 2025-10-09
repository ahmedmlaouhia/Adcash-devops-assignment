import express, { Request, Response } from "express"
import path from "path"

const app = express()
const port = 3000

const staticDir = path.join(__dirname, "..", "public")
app.use("/static", express.static(staticDir))

app.get("/gandalf", (_req: Request, res: Response) => {
  res.type("html").send(`
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <title>that's Gandalf</title>
      </head>
      <body>
        <main>
          <img src="/static/gandalf.jpg" alt="Gandalf's picture" style="max-height: 90vh; max-width: 90%; width: fit-content;" />
        </main>
      </body>
    </html>
  `)
})

app.get("/", (_req: Request, res: Response) => {
  res.json({ message: "Go to /gandalf or /colombo!" })
})

app.listen(port, "0.0.0.0", () => {
  console.log(`Server listening on http://localhost:${port}`)
})
