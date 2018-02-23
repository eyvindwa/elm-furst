import Html exposing (..)
import Html.Attributes exposing ( .. )
import Html.Events exposing ( .. )
import Http
import Json.Decode exposing ( .. )

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : (Model, Cmd Msg)
init = 
    (initialModel, Cmd.none)

-- MODEL - a representation of our data/state
type alias Doctor = { name : String, requisitionsYTD : Int }

type alias Model = { 
  doctors : List Doctor,
  currentDocName : String,
  currentNumberOfReqs : String  
  }

initialModel : Model
initialModel = { 
  doctors = [ { name = "Dr No", requisitionsYTD = 0 } ], 
  currentDocName = "",
  currentNumberOfReqs = ""
  }

type Msg = AddDoctor Doctor 
  | RemoveDoctor Doctor 
  | OnInputDocName String 
  | OnInputReqNo String
  | GetDocsFromApi
  | GotDocsFromApi (Result Http.Error String)


-- UPDATE - a function takes in a message and a model, and returns a new (updated) model
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddDoctor doc -> ( { model | doctors = doc :: model.doctors }, Cmd.none)
    RemoveDoctor doc -> ( model, Cmd.none)
    OnInputDocName str -> ( { model | currentDocName = str  }, Cmd.none)
    OnInputReqNo str -> ({ model | currentNumberOfReqs = str}, Cmd.none)
    GetDocsFromApi -> (model, Http.send GotDocsFromApi callApi )
    GotDocsFromApi result -> 
      case result of 
        Err err -> 
          let
            _ = Debug.log "I failed" err
          in
            (model, Cmd.none)
        Ok name ->
          ({ model | doctors = ({ name = name, requisitionsYTD = 0 } :: model.doctors) }, Cmd.none)

url = "http://localhost:3000/docs"

callApi : Http.Request String
callApi = Http.get url decodeResult

decodeResult : Json.Decode.Decoder String
decodeResult = at ["name"] string
    
-- VIEW - a function turns models into Html
view : Model -> Html Msg
view model =
  body [ ] [
    h1 [ ] [ text "Welcome to the fantastic doctor app!"],
    ul [ ] (listDoctors model.doctors),
    input [ type_ "text", placeholder "Doctor name", onInput OnInputDocName ] [] ,
    input [ type_ "number", placeholder "Requisitions ytd", onInput OnInputReqNo  ] [],
    button [ onClick (AddDoctor { name = model.currentDocName, requisitionsYTD = 0}) ] [ text "Add doctor"],
    button [ onClick GetDocsFromApi ] [ text "Get me som docs!"]
  ]

listDoctors : List Doctor -> List (Html Msg)
listDoctors docs = List.map (\d -> li [] [ text d.name ]) docs


-- Today's task: create a website where users can add Doctors with the
-- number of requisitions YTD (like a real pro marketing app!)