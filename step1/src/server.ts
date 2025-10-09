import express, { Request, Response } from "express"
import { DateTime } from "luxon"
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

app.get("/colombo", (_req: Request, res: Response) => {
  const now = DateTime.now().setZone("Asia/Colombo")
  const time = now.toFormat("HH:mm:ss")
  const date = now.toFormat("dd LLLL yyyy")

  res.type("html").send(`
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <title>Colombo time</title>
        <style>
          body { margin: 0; background: #041727; color: #f5f5f5; display: flex; align-items: center; justify-content: center; height: 100vh; }
          main { text-align: center; padding: 2rem; }
          h2 { font-size: 2rem; margin-bottom: 1rem; }
          h3 { font-size: 1.5rem; }
        </style>
      </head>
      <body>
        <main>
          <h2>The time in Colombo, Sri Lanka is:</h2>
          <h3>${time}</h3>
          <h3>${date}</h3>
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
