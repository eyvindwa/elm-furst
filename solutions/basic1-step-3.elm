import Html exposing ( .. )
import Html.Events exposing ( .. )
import Html.Attributes exposing ( .. )
import Http
import Json.Decode

main : Program Never Model Msg
main =
    Html.program
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
    }

-- MODEL - a representation of our data/state
type alias Model = { 
    doctors : List Doctor,
    currentDocName : String,
    currentDocReqsYTD : String,
    doctorsFromApi : String
 }

initialModel : (Model, Cmd Msg) 
initialModel = ( { 
        doctors = [ { name = "Dr. Who", requisitionsYTD = 0 }],
        currentDocName = "",
        currentDocReqsYTD = "",
        doctorsFromApi = ""
    }, Cmd.none)

type alias Doctor = { name : String, requisitionsYTD: Int }

-- UPDATE - a function takes in a message and a model, and returns a new (updated) model
type Msg = AddDoctor Doctor | RemoveDoctor Doctor | 
    SetCurrentDocName String | SetCurrentDocReqs String |
    GetDocsFromApi | GotDocsFromApi (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddDoctor doc -> ( { model | doctors = doc :: model.doctors }, Cmd.none)
    RemoveDoctor doc -> ( { model | doctors = List.filter (\d -> d /= doc) model.doctors }, Cmd.none)
    SetCurrentDocName n -> ( { model | currentDocName = n }, Cmd.none)
    SetCurrentDocReqs r -> ( { model | currentDocReqsYTD = r}, Cmd.none)
    GetDocsFromApi  -> (model, Http.send GotDocsFromApi callApi )
    GotDocsFromApi result -> 
        case result of
            Err error -> 
                let 
                    _ = Debug.log "failed" error
                in
                    (model, Cmd.none )
            Ok str ->
                ( { model | doctorsFromApi = str}, Cmd.none )

url = "http://localhost:3000/docs"

callApi = Http.get url decodeResult

decodeResult : Json.Decode.Decoder String
decodeResult = Json.Decode.at ["name"] Json.Decode.string

--- Subscriptions: listen for incoming data
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- VIEW - a function turns models into Html
view : Model -> Html Msg
view model =
  body [] [
      h1 [] [ text "Here is a list of doctors"],
      ul [] (docList model.doctors),
      h2 [] [ text "Add new doctor:"],
      input [ type_ "text", placeholder "Doc name", onInput SetCurrentDocName ] [],
      input [ type_ "text", placeholder "Number of requisitions YTD", onInput SetCurrentDocReqs ] [],
      button [ onClick ( AddDoctor { 
          name = model.currentDocName, requisitionsYTD = model.currentDocReqsYTD |> String.toInt |> Result.toMaybe |> Maybe.withDefault -1
        }) ] [ text "Add new doc" ],
       input [ type_ "text", value model.doctorsFromApi, placeholder "Doctors fetched from backend"] [],
       button [ onClick GetDocsFromApi ] [ text "Fetch me some docs!"]
  ]

docList : List Doctor -> List (Html Msg)
docList doctors = 
  List.map (\d -> li [] [ 
    text (d.name ++ " " ++ (toString d.requisitionsYTD )),
    button [ onClick (RemoveDoctor d) ] [ text "Remove doc" ]
    ]) doctors

