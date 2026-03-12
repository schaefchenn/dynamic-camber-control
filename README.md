# dynamic-camber-control

This repository contains the implementation of a **camber control algorithm** developed within the university module **Active Suspension Systems** at HAW Hamburg.

The project aims to introduce students to the **automotive V-Model development process** by guiding them through the design and validation of an **active suspension control function**.

The controller determines an **optimal wheel camber angle** based on vehicle dynamics data. The development process follows a **simulation-based workflow** using **CarMaker** and **MATLAB/Simulink**.

The final controller is exported as a **Functional Mock-up Unit (FMU)** and integrated into the **CarMaker simulation environment**.

---

## Development Workflow & Git Setup

Since this project uses **MATLAB/Simulink** models (`.slx`), we use native MathWorks tools for version control to enable visual diffing and merging of binary model files.

### 1. Prerequisites
To work on this project, ensure you have the following software installed:
* **Operating System:** Windows 11 (64-bit)
* **Simulation Software:** IPG Automotive CarMaker 12.x
* **Mathematical Software:** MATLAB (R2025b or newer)

### 2. Configure Git for Simulink
To enable visual comparisons and conflict resolution for Simulink files within Git, execute the following command in your **MATLAB Command Window**:

```matlab
comparisons.ExternalSCMLink.setupGitConfig()