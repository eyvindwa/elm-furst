import Html exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }


type alias Model =
    { property : propertyType
    }


type Msg
    = msg1
    | msg2


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        msg1 ->
            (model, Cmd.none)

        msg2 ->
            (model, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ text "New Html Program" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : (Model, Cmd Msg)
init = 
    (Model modelInitialValue, Cmd.none)
