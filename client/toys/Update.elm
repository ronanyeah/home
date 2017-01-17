module Update exposing (..)

import Random
import Task
import Time exposing (Time, every, second)
import Dict exposing (Dict)
import Navigation
import Keyboard
import Mouse
import Http
import Json.Decode exposing (Decoder, at, list, string)
import Model exposing (..)

-- UPDATE


type Msg
    = Click ( Int, Int )
    | Interval Time
    | Split (Int, Int, (Int, Int))
    | Step (Int, Int, (Int, Int))
    | UrlChange Navigation.Location
    | MouseMsg Mouse.Position
    | KeyMsg Keyboard.KeyCode
    | UpdateTopic String
    | Then (Result Http.Error (List String))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- CRACKS
        Step (p, t, xy) ->
          if p < 20
          then (model, Cmd.none)
          else (
            model,
            Random.generate (\p -> Split ( p, t, xy )) (Random.int 0 3)
          )

        UrlChange location ->
          ( { model | history = location :: model.history
            , view = location.hash
            }
          , Cmd.none
          )

        Split (q, t, xy) ->
          let
              next = nextSquare t q xy
          in
            (
              { model | cracks = Dict.insert next True model.cracks },
              Random.generate (\q -> Step ( q, t, next )) (Random.int 1 100)
            )

        Click ( x, y ) ->
          (
            { model | cracks = Dict.insert (x,y) True model.cracks },
            Cmd.batch (split (x, y))
          )

        Interval _ ->
          (
            model,
            Random.generate Click (Random.pair (Random.int 1 100) (Random.int 1 100))
          )

        -- GIFS
        UpdateTopic value ->
            ( { model | gifs = Gifs model.gifs.urls value }, Cmd.none )

        Then (Ok data) ->
            ( { model | gifs = Gifs data "" }, Cmd.none )

        Then (Err err) ->
            ( model, Cmd.none )

        KeyMsg code ->
            case code of
                13 ->
                    ( model, hit model.gifs.topic )

                _ ->
                    ( model, Cmd.none )

        MouseMsg _ ->
            ( { model | gifs = Gifs [] model.gifs.topic }, Cmd.none )

hit : String -> Cmd Msg
hit topic =
    let
        url =
            "http://api.giphy.com/v1/gifs/search?q=" ++ topic ++ "&limit=40&api_key=dc6zaTOxFJmzC"
    in
        Http.send Then (Http.get url decoder)

decoder : Decoder (List String)
decoder =
    at [ "data" ]
        (list
            (at [ "images", "original", "mp4" ] string)
        )

nextSquare : Int -> Int -> (Int, Int) -> (Int, Int)
nextSquare direction quadrant (x, y) =
  let
      q = quadrant
  in
      case direction of
        0 ->
          case q of
            0 -> ( x - 1, y )
            3 -> ( x, y + 1 )
            _ -> ( x - 1, y + 1 )
        1 ->
          case q of
            0 -> ( x, y + 1 )
            3 -> ( x + 1, y )
            _ -> ( x + 1, y + 1 )
        2 ->
          case q of
            0 -> ( x + 1, y )
            3 -> ( x, y - 1 )
            _ -> ( x + 1, y - 1 )
        3 ->
          case q of
            0 -> ( x, y - 1 )
            3 -> ( x, y + 1 )
            _ -> ( x - 1, y - 1 )
        _ -> ( x, y )

msgToCmd : msg -> Cmd msg
msgToCmd msg =
  Task.perform identity (Task.succeed msg)

split : (Int, Int) -> List (Cmd Msg)
split xy =
  List.map
  (\direction ->
    msgToCmd (Step ( 100, direction, xy ))
  )
  [0, 1, 2, 3]
