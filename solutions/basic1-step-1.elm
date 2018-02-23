import Html exposing (..)

main = beginnerProgram { model = initialModel, view = view, update = update }

-- MODEL - a representation of our data/state
type alias Model = { 
    doctors : List Doctor
 }

initialModel : Model 
initialModel = { doctors = [ { name = "Dr. Who", requisitionsYTD = 0 }]}

type alias Doctor = { name : String, requisitionsYTD: Int }

-- UPDATE - a function takes in a message and a model, and returns a new (updated) model
type Msg = AddDoctor Doctor | RemoveDoctor Doctor

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddDoctor doc -> model
    RemoveDoctor doc -> model
    

-- VIEW - a function turns models into Html
view : Model -> Html Msg
view model =
  body [] [
      h1 [] [ text "What a great app we have!"]
  ]