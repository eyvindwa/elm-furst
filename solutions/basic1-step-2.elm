import Html exposing ( .. )
import Html.Events exposing ( .. )
import Html.Attributes exposing ( .. )

main = beginnerProgram { model = initialModel, view = view, update = update }

-- MODEL - a representation of our data/state
type alias Model = { 
    doctors : List Doctor,
    currentDocName : String,
    currentDocReqsYTD : String
 }

initialModel : Model 
initialModel = { 
  doctors = [ { name = "Dr. Who", requisitionsYTD = 0 }],
  currentDocName = "",
  currentDocReqsYTD = ""
  }

type alias Doctor = { name : String, requisitionsYTD: Int }

-- UPDATE - a function takes in a message and a model, and returns a new (updated) model
type Msg = AddDoctor Doctor | RemoveDoctor Doctor | SetCurrentDocName String | SetCurrentDocReqs String

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddDoctor doc -> { model | doctors = doc :: model.doctors }
    RemoveDoctor doc -> { model | doctors = List.filter (\d -> d /= doc) model.doctors }
    SetCurrentDocName n -> { model | currentDocName = n }
    SetCurrentDocReqs r -> { model | currentDocReqsYTD = r}
    

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
        }) ] [ text "Add new doc" ]
  ]

docList : List Doctor -> List (Html Msg)
docList doctors = 
  List.map (\d -> li [] [ 
    text (d.name ++ " " ++ (toString d.requisitionsYTD )),
    button [ onClick (RemoveDoctor d) ] [ text "Remove doc" ]
    ]) doctors

