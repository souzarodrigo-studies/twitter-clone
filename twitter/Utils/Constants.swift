//
//  Constants.swift
//  twitter
//
//  Created by Rodrigo Santos on 24/03/21.
//

import Firebase
import FirebaseStorage
import FirebaseDatabase

let AUTH_FIREBASE = Auth.auth()
let STORAGE_FIREBASE = Storage.storage().reference()
let DATABASE_FIREBASE = Database.database().reference()

let REFERENCE_USERS = DATABASE_FIREBASE.child("users")
let REFERENCE_TWEETS = DATABASE_FIREBASE.child("tweets")
let REFERENCE_USER_TWEETS = DATABASE_FIREBASE.child("user-tweets")
let STORAGE_PROFILE_IMAGES = STORAGE_FIREBASE.child("profile_images")
