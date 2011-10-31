{-# LANGUAGE DeriveDataTypeable, OverloadedStrings #-}

module Github.Data (module Github.Data.Definitions) where

import Data.Time
import Control.Applicative
import Control.Monad
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.Aeson.Types
import System.Locale (defaultTimeLocale)

import Github.Data.Definitions

instance FromJSON GithubDate where
  parseJSON (String t) =
    case parseTime defaultTimeLocale "%FT%T%Z" (T.unpack t) of
         Just d -> pure $ GithubDate d
         _      -> fail "could not parse Github datetime"
  parseJSON v   = fail "Given something besides a String"

instance FromJSON Commit where
  parseJSON (Object o) =
    Commit <$> o .: "sha"
           <*> o .: "parents"
           <*> o .: "url"
           <*> o .: "commit"
           <*> o .:? "committer"
           <*> o .:? "author"
  parseJSON _          = fail "Could not build a Commit"

instance FromJSON Tree where
  parseJSON (Object o) =
    Tree <$> o .: "sha" <*> o .: "url"
  parseJSON _          = fail "Could not build a Tree"

instance FromJSON GitCommit where
  parseJSON (Object o) =
    GitCommit <$> o .: "message"
              <*> o .: "url"
              <*> o .: "committer"
              <*> o .: "author"
              <*> o .: "tree"
  parseJSON _          = fail "Could not build a GitCommit"

instance FromJSON GithubUser where
  parseJSON (Object o) =
    GithubUser <$> o .: "avatar_url"
               <*> o .: "login"
               <*> o .: "url"
               <*> o .: "id"
               <*> o .: "gravatar_id"
  parseJSON v          = fail $ "Could not build a GithubUser out of " ++ (show v)

instance FromJSON GitUser where
  parseJSON (Object o) =
    GitUser <$> o .: "name"
            <*> o .: "email"
            <*> o .: "date"
  parseJSON _          = fail "Could not build a GitUser"
