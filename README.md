# Classroom Hub

Self-service repo provisioning for your courses — replaces GitHub Classroom.
Everything happens through **Issues** on this repo.

## 🚀 How to open a form

Two ways:

- **Easiest:** click the link your instructor posted on **Canvas** — it opens the right form directly.
- **Manually, here on GitHub:**

```
  [ <> Code ]  [ ⊙ Issues ]  [ ⇄ Pull requests ]  ...      1. click the  "Issues"  tab  ↑
                                                            2. click the green  [ New issue ]  button (top-right)
                                                            3. pick a form (below)
```

(“Blank issue” is **maintainers only** — students use the forms.)

## The forms

### 1. Register — once per term (safe to repeat)
Fill in **Name**, **Email**, and **Code** (the class join code from your Canvas course page).
Your GitHub username is captured automatically. Made a typo? Just register again — it overwrites.

### 2. Request a `<course>` repo
Pick the assignment → you get a **private** repo `…-<assignment>-<your-username>` and an **invitation**.
Accept the invite (link is in the confirmation comment), then `gh repo clone …`.
Re-requesting the same assignment is safe — it returns your existing repo.

### 3. My repos
Just **Submit** (nothing to fill in) → you get a comment listing **all** your repos, with links.

---

**Not registered?** A request is rejected with the Register link — register first
(it's instant once you use the class code).

**Instructor:** course/assignment/semester values live in this repo's `config.json` (one per school).
Edit it (here on GitHub or a clone) and the **gen-forms** Action regenerates the request forms
automatically. This repo is a fork of `gh-classroomless/classroom-template`; code fixes arrive by merging the
template. Student PII (name/email) and the submission report live in the private `…-admin` repo, never here.

**Deploying this for your own school?** See the [gh-classroomless org page](https://github.com/gh-classroomless).
