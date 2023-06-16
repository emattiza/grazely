module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onResize)
import Elm2D
import Elm2D.Color
import Elm2D.Spritesheet exposing (Sprite, Spritesheet)
import Html exposing (Html)


type alias Flags =
    { screenDimensions : ( Int, Int )
    , tileURL : String
    }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { spritesheet : Spritesheet
    , screenSize : ( Float, Float )
    , counter : Int
    }


init : Flags -> ( Model, Cmd Msg )
init { tileURL, screenDimensions } =
    let
        ( width, height ) =
            screenDimensions
    in
    ( { spritesheet = Elm2D.Spritesheet.blank
      , screenSize = ( toFloat width, toFloat height )
      , counter = 0
      }
    , Elm2D.Spritesheet.load
        { tileSize = 16
        , file = tileURL -- https://fikry13.itch.io/another-rpg-tileset
        , onLoad = LoadedSpritesheet
        }
    )



-- UPDATE


type Msg
    = LoadedSpritesheet Spritesheet
    | ScreenResized Int Int
    | TickAnimation Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadedSpritesheet spritesheet ->
            ( { model | spritesheet = spritesheet }
            , Cmd.none
            )

        ScreenResized width height ->
            ( { model | screenSize = ( toFloat width, toFloat height ) }
            , Cmd.none
            )

        TickAnimation _ ->
            ( { model | counter = modBy 640 (model.counter + 1) }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onResize ScreenResized
        , onAnimationFrameDelta TickAnimation
        ]



-- VIEW


view : Model -> Html msg
view model =
    let
        sprites =
            spritesFor model.spritesheet

        field height =
            List.range 0 15
                |> List.map toFloat
                |> List.map (\x -> Elm2D.sprite { sprite = sprites.grass, position = ( x * 32, height ), size = ( 34, 32 ) })

        fields =
            List.range 0 9
                |> List.map (\i -> field <| toFloat (i * 32))
                |> List.concat

        chestAndSky =
            [ Elm2D.rectangle
                { color = Elm2D.Color.fromRgb255 ( 50, 149, 168 )
                , position = ( 0, 0 )
                , size = ( 480, 160 )
                }
            ]

        total =
            List.concat [ fields, chestAndSky ]
    in
    Elm2D.view
        { size = ( 480, 320 )
        , background = Elm2D.Color.fromRgb ( 0.25, 0.7, 0.5 )
        }
        total


spritesFor :
    Spritesheet
    ->
        { chest : Sprite
        , rock : Sprite
        , bush : Sprite
        , grass : Sprite
        }
spritesFor sheet =
    let
        select =
            Elm2D.Spritesheet.select sheet
    in
    { chest = select ( 2, 6 )
    , rock = select ( 7, 4 )
    , bush = select ( 5, 4 )
    , grass = select ( 15, 9 )
    }
