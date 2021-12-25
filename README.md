<div id="top"></div>
<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/vineet2420/pair-finder">
    <img src="readmeFiles/logo.png" alt="Logo" width="150">
  </a>

  <h3 align="center">Activity Matcher/Pair Finder</h3>
  <p align="center">
    A quick cross platform application built to connect nearby users  <br /> with shared interests. 
  </p>
</div>

<!-- TABLE OF CONTENTS 
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

-->

<!-- ABOUT THE PROJECT -->
## Background

The modern world feels like a very small place with six degrees of separation and social networking apps increasing visibility to everyone on its platform around the world. Yet why is it the case when we explore a new city for the first time, it is as if we are completely alone and left to make new connections by ourselves? Is there a better solution? iPair seeks to help individuals meet new people and engage in their activities together. 

> Goal: Get users off the app as quick as possible. 🤔

The point is not to squeeze as much capital out of each user and profit from obtrusive advertisements. Everything about the application is developed to be as intuitive, quick, and seamless as to not detract from your activities.

<details open>

<summary>Hide Demo</summary>
<img src="readmeFiles/demo.gif" width=400px>

</details>

<p align="right">(<a href="#top">back to top</a>)</p>

### Built With

Front end:

* [Flutter - UI Framework](https://flutter.dev/)
	* [Dart - Language used within Flutter](https://dart.dev/)

Back end:

* [AWS EC2 Ubuntu 18.04.6 LTS - Hosting](https://aws.amazon.com/ec2/)
* [Apache 2 HTTP Server - Web Server](https://httpd.apache.org/)
* [Gunicorn 'Green Unicorn' - Python Web Server Gateway Interface](https://gunicorn.org/)
* [Flask Microframework - REST API](https://flask.palletsprojects.com/en/2.0.x/)
* [PostgreSQL - Relational Database](https://www.postgresql.org/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

Run this project within your own environment.

### Prerequisites

* [Install Flutter - https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
* [Install PostgreSQL - https://www.postgresql.org/download/](https://www.postgresql.org/download/)
### Installation

1. Clone the repo
   ```
   git clone https://github.com/vineet2420/pair-finder.git
   ```
   
   or w/ ssh
   ```
   git clone git@github.com:vineet2420/pair-finder.git
   ```
2. Change directories 
   ```
   cd pair-finder/flutter-ui/
   ```
3. Get dependencies 
	```
	flutter pub get
	```
4. Open `flutter-ui` folder with Android Studio or VSCode

### Configuration

Set up database

1. Login 
	```
	psql -U "username"
	``` 
	and follow password prompt.
2. Create coredb database 
	```
	CREATE DATABASE coredb;
	```
3. Connect to coredb
	```
	\c coredb;
	```
4. Create tables

	4a. User Table 
	
	```
	CREATE TABLE "user" (uid SERIAL PRIMARY KEY, first_name CHARACTER VARYING(50)[] NOT NULL, last_name CHARACTER VARYING(50)[] NOT NULL, email CHARACTER VARYING(255)[] NOT NULL, username CHARACTER VARYING(15)[] NOT NULL, password CHARACTER VARYING(64)[] NOT NULL, radius FLOAT);
	```
	Expected output: CREATE TABLE
	
	4b. Activities Table
	
	```
	CREATE TABLE "activities" (aid SERIAL PRIMARY KEY, owner TEXT NOT NULL, act_name TEXT NOT NULL, act_desc TEXT NOT NULL, act_latitude FLOAT NOT NULL, act_longitude FLOAT NOT NULL, pair TEXT, time TEXT NOT NULL, address TEXT NOT NULL);
	```
	Expected output: CREATE TABLE

Set up local web server

1. Change directory _(from flutter-ui)_
	```
	cd ../flask-server/
	```
2. 


<!--
1. Enter your API in `config.js`
   ```js
   const API_KEY = 'ENTER YOUR API';
   ```
2. Get a free API Key at [https://example.com](https://example.com)
-->
<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Add Additional Templates w/ Examples
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
    - [ ] Chinese
    - [ ] Spanish

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)

<p align="right">(<a href="#top">back to top</a>)</p>