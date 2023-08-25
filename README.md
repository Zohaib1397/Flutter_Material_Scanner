# Material Scanner

## Introduction

The idea is to implement a document scanner application that can export images/documents to pdf and OCR feature.
Following are some listed features that are needed to be considered.

## Feature set

<ol>
        <li>
            <p><strong>Image Capture:</strong></p>
            <p>Allow users to capture images of documents using their device's camera. Provide real-time preview for adjusting document positioning and quality before capturing.</p>
        </li>
        <li>
            <p><strong>Image Processing:</strong></p>
            <p>Implement image enhancement techniques to improve the quality of scanned documents (e.g., cropping, rotation, brightness/contrast adjustment). Use edge detection algorithms to identify and enhance text and document edges.</p>
        </li>
        <li>
            <p><strong>Optical Character Recognition (OCR):</strong></p>
            <p>Integrate OCR technology to convert scanned text into editable and searchable content. Support multiple languages and fonts for accurate text recognition.</p>
        </li>
        <li>
            <p><strong>Document Format Conversion:</strong></p>
            <p>Convert scanned documents to popular formats like PDF, JPEG, or PNG. Maintain high-quality formatting during conversion.</p>
        </li>
        <li>
            <p><strong>Auto-Crop and Deskew:</strong></p>
            <p>Automatically detect document boundaries and crop unnecessary background. Correct skewed documents to ensure they are aligned properly.</p>
        </li>
        <li>
            <p><strong>Batch Scanning:</strong></p>
            <p>Allow users to scan multiple documents in succession and organize them into a single file or separate files.</p>
        </li>
        <li>
            <p><strong>Cloud Integration:</strong></p>
            <p>Provide options to save scanned documents to cloud storage services (e.g., Google Drive, Dropbox) for easy access and backup.</p>
        </li>
        <li>
            <p><strong>Search and Organization:</strong></p>
            <p>Implement a search function to locate specific documents based on keywords. Enable users to organize scanned documents into folders or categories.</p>
        </li>
        <li>
            <p><strong>Security and Privacy:</strong></p>
            <p>Ensure secure data transmission and storage of scanned documents. Implement user authentication and authorization mechanisms to protect sensitive information.</p>
        </li>
        <li>
            <p><strong>User-Friendly Interface:</strong></p>
            <p>Design an intuitive and user-friendly interface with easy-to-use controls. Offer clear instructions and feedback during the scanning process.</p>
        </li>
        <li>
            <p><strong>Offline Mode:</strong></p>
            <p>Allow users to scan documents without requiring an active internet connection. Sync and upload scanned documents when the device is back online.</p>
        </li>
        <li>
            <p><strong>Accessibility Features:</strong></p>
            <p>Ensure the application is accessible to users with disabilities by following accessibility guidelines.</p>
        </li>
        <li>
            <p><strong>Device Compatibility:</strong></p>
            <p>Optimize the application to work smoothly on a variety of devices, including smartphones and tablets.</p>
        </li>
    </ol>

## Business Perspective

The main perspective of building this application is to have a use-full tool and practice on the coding standards such as clean architecture, and Material 3 deign structure. Later-on, the application will be deployed on App Store and PlayStore with in app-purchases. 

## Design Structure
 The design of the application is inspired completely from Material You released by google development team. 

 <img width="730" alt="Your Documents" src="https://github.com/Zohaib1397/Flutter_Material_Scanner/assets/66197508/2ac81bda-2248-4fb3-a3c8-10082f64eb58"><br>
￼
The application will feature a home screen with two possible layout structure i.e. grid layout & linear layout. A camera FAB is used to scan a new or list of images. If the user selects for the Burst of images then a folder will be created automatically.   
