# Image Analysis and Computer Vision (IACV) - Homework 2024/2025

## Overview
This repository contains the homework assignments for the **Image Analysis and Computer Vision** (IACV) course at **Politecnico di Milano** for the academic year **2024-2025**.

All implementation details, methodology, and results can be found in the accompanying **report**.

## Implemented Techniques
The following computer vision and image analysis techniques have been implemented and analyzed:

### 1. **Edge Detection**
- **Canny Edge Detection**: Applied for detecting edges in images by finding areas with rapid intensity change.
- Reference: [Canny Edge Detection - MATLAB](https://it.mathworks.com/help/images/ref/edge.html)

### 2. **Feature Detection and Extraction**
- **Hough Transform**: Used for detecting geometric shapes (e.g., lines, circles) in an image.
- Reference: [Hough Transform - MATLAB](https://it.mathworks.com/help/images/hough-transform.html)

- **Harris Corner Detection**: Applied to detect corner features in images for further processing in feature matching.
- Reference: [Harris Features - MATLAB](https://it.mathworks.com/help/vision/ref/detectharrisfeatures.html)

### 3. **Camera Calibration**
- **Zhang’s Camera Calibration**: Implemented using a flexible technique for intrinsic and extrinsic parameter estimation.
- Reference: [A Flexible New Technique for Camera Calibration - Zhengyou Zhang](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr98-71.pdf)

- **Absolute Quadratic Curve Calibration**: Applied based on image-based calibration methods.
- Reference: [Calibration Method Based on the Image of the Absolute Quadratic Curve - Wenlei Liu et al.](https://ieeexplore.ieee.org/document/8616767)

### 4. **Linear Algebra Applications in Vision**
- **Cholesky Factorization**: Used for solving optimization problems in image processing and calibration.
- Reference: [Cholesky Factorization - MATLAB](https://it.mathworks.com/help/matlab/ref/chol.html)

## Additional Resources
- Lecture notes and materials from **Luca Magri's IACV course**: [IACV Materials](https://magrilu.github.io/iacv/)

## Repository Structure
```
📂 IACV_Homework_2024-2025
│-- 📁 src/                      # Implementation files (MATLAB) 
│-- 📁 ellipse_functions/        # Functions to work with ellipses 
│-- 📁 feature_extracture_functions/ # Functions for part0
│-- 📁 images/                   # Results of applied transformations and feature extraction functions
│-- README.md                    # Project overview (this file)
```

## How to Use
1. Clone the repository:
   ```sh
   git clone https://github.com/SAFUANlip/IACV_Homework_2024-2025.git
   ```
2. Navigate to the repository:
    ```sh
    cd IACV_Homework_2024-2025
    ```
3. Run the scripts in ```src/``` directory using MATLAB.

## Contact Information
* Iusupov Safuan [Telegram](https://t.me/IusupovSafuan) | [GitHub](https://github.com/SAFUANlip) | safuan.iusupov@mail.polimi.it

