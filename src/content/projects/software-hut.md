---
title: "Software Hut Project"
description: "A full-stack platform for querying, annotating, and browsing interactive golf course maps, built for a real client with a 7-person team through the University of Sheffield's Software Hut module."
date: "February – May 2023"
tags: ["Ruby", "Rails", "JavaScript"]
repo: "https://github.com/jacksanders02/strokes-gained"
---

**95% individual grade · Software Hut Prize (Client Awarded)**

The project involved creating a system enabling clients to query data about golf courses. Through weekly client meetings, the team gathered requirements via story cards and mockup diagrams. The system features two primary roles: map creators who design detailed hole maps, and regular users who leverage this data to improve their game using the "strokes gained" metric.

### Login

The application includes a login interface with golf course imagery in the background.

### Map creator functionality

Map interactions were built with Leaflet for the base map and Leaflet Geoman for drawing capabilities. Custom polygon controls were created for different terrain types, styled with SCSS variables to maintain consistency across the interface. Map creators can assign tags (such as "In Development" or "Complete") to control user visibility. The Overpass Turbo API pre-populated the database with golf course locations from OpenStreetMap, so creators only needed to add hole details.

### User annotation

Users can annotate maps in the same way as creators, with their annotations stored in personal database tables rather than the shared course databases.

### Shot optimisation algorithm

An algorithm lets users identify optimal shots: the system samples points across dispersion patterns, calculates average strokes gained within a 150° cone centred on the hole, and accounts for tree obstruction — marking shots as blocked if within 20 metres of intersecting trees, based on an assumed 20-metre tree height derived from ball trajectory physics.
