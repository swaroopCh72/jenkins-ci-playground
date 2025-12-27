
---

# 🧑‍💻 Jenkins CI Pipeline Walkthrough (From Zero to Working CI)

This repository documents my **hands-on journey of setting up Jenkins CI from scratch**, starting with a basic freestyle job and gradually evolving into a **Docker-based Jenkins pipeline**.

This project intentionally includes **failures, debugging, and fixes**, because real CI/CD work is not linear.
The final result is a **fully working Jenkins pipeline** using Docker agents.

---

## 📌 Goal of This Project

* Learn Jenkins **the right way**, not just make it “work”
* Understand how Jenkins behaves when running inside Docker
* Build confidence handling **real CI failures**
* Reach a **job-ready CI setup**, not an over-engineered one

---

## 🧱 Phase 1: Installing Jenkins Using Docker

Jenkins was installed **inside Docker**, following the **official Jenkins documentation**.

### Why Docker?

* Clean setup
* Easy restart and recovery
* Industry-standard for CI servers

### Jenkins Run Command

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  jenkins/jenkins:lts
```

### What this setup provides:

* Persistent Jenkins data (`jenkins_home` volume)
* Ability for Jenkins to run Docker commands
* Stable LTS Jenkins version

Jenkins UI was accessed at:

```
http://localhost:8080
```

---

## 🧱 Phase 2: Jenkins Initial Setup

* Unlocked Jenkins using the initial admin password
* Installed **recommended plugins**
* Created an admin user
* Verified Jenkins was running correctly

At this point, Jenkins was **clean and empty**.

---

## 🧱 Phase 3: First Jenkins Job (Freestyle – Hello World)

To understand Jenkins basics, I created a **Freestyle Job**.

### What it did:

* Ran a simple Python script
* Printed `Hello World` in console output

Example command executed:

```bash
python hello.py
```

This step helped me understand:

* How Jenkins executes jobs
* How console output works
* How builds are triggered manually

✅ **Build succeeded on first try**

---

## 🧱 Phase 4: Moving from Freestyle to Pipeline (Jenkinsfile)

After understanding freestyle jobs, I moved to **Pipeline Jobs**, which are the industry standard.

### Why Pipeline?

* CI configuration as code
* Version controlled
* Reproducible builds
* Scales better in real teams

I created a **new branch**:

```
ci-test
```

and added a `Jenkinsfile` to it.

---

## 🧱 Phase 5: Jenkins + GitHub Integration (SSH)

Since Jenkins was running inside Docker, it needed **its own SSH key**.

Steps taken:

1. Generated SSH key **inside Jenkins container**
2. Added public key to GitHub
3. Verified connection using:

```bash
ssh -T git@github.com
```

This allowed Jenkins to clone the repository securely.

---

## 🧱 Phase 6: Docker-Based Jenkins Agent (Real CI Begins)

The pipeline was updated to use a **Docker agent** instead of running directly on Jenkins.

### Key decision:

* Use **Docker-based Jenkins agent**
* Reuse host Docker daemon via socket mount

```groovy
agent {
    docker {
        image 'docker:25'
        args '-v /var/run/docker.sock:/var/run/docker.sock --user root'
    }
}
```

This is a **very common industry setup**.

---

## 🧱 Phase 7: CI Pipeline Logic

The pipeline performs the following steps:

1. Checkout source code
2. Build Docker image
3. Run application container
4. Perform health check inside container
5. Clean up test container

---

## 🧱 Phase 8: The Reality — 6 Builds, 5 Failures

This phase is the **core learning** of the project.

### ❌ Build Failures Encountered

Over **6 pipeline runs**, the first **5 failed**, each for a different real-world reason:

1. ❌ Jenkinsfile not picked (wrong job type)
2. ❌ Wrong Git branch configured (`main` vs `ci-test`)
3. ❌ Docker socket permission denied
4. ❌ Docker client ↔ daemon API version mismatch
5. ❌ Health check failed due to missing `curl`
6. ❌ Package manager mismatch (`apt` vs `apk`)

Each failure was:

* Investigated via console logs
* Understood
* Fixed incrementally

No steps were skipped.

---

## 🧱 Phase 9: Final Working Pipeline

### Health Check Implementation

```bash
docker exec ci-test curl -f http://localhost:8000/
```

Health check runs **inside the container**, avoiding Docker networking issues.

### Cleanup

```groovy
post {
    always {
        sh 'docker rm -f ci-test || true'
    }
}
```

Ensures CI environment stays clean.

---

## ✅ Final Result

🎉 **Pipeline finished successfully**

* Docker image built
* Container started
* Health check passed
* Container cleaned up
* Jenkins pipeline green

This was achieved after **6 builds**, not on the first try — intentionally documented.

---

## 🧠 Key Learnings

* Jenkins agents are isolated execution environments
* `localhost` means different things in Docker contexts
* Docker socket permissions matter
* Docker client and daemon versions must match
* CI containers should be ephemeral
* Failures are part of real CI work

---

## 🎯 Why This Project Matters

This project is **not a tutorial copy**.

It demonstrates:

* Debugging skills
* Incremental problem solving
* Real CI/CD understanding
* Comfort with failure and recovery

This is **job-level Jenkins knowledge**, not surface-level familiarity.

---

## 📄 License

This project is created for **learning and demonstration purposes**.

---


