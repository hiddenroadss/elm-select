module Tag exposing (default, onDismiss, onMousedown, onMouseleave, truncateWidth, view)

import ClearIcon
import Css
import Html.Styled exposing (Html, div, span, text)
import Html.Styled.Attributes as StyledAttribs
import Html.Styled.Events exposing (on, onClick)
import Json.Decode as Decode


type Config msg
    = Config (Configuration msg)


type alias Configuration msg =
    { onDismiss : Maybe msg
    , onMousedown : Maybe msg
    , onMouseleave : Maybe msg
    , truncationWidth : Maybe Float
    }



-- VARIANTS


defaults : Configuration msg
defaults =
    { onDismiss = Nothing
    , onMousedown = Nothing
    , onMouseleave = Nothing
    , truncationWidth = Nothing
    }



-- MODIFIERS


default : Config msg
default =
    Config defaults


onDismiss : msg -> Config msg -> Config msg
onDismiss msg (Config config) =
    Config { config | onDismiss = Just msg }


onMousedown : msg -> Config msg -> Config msg
onMousedown msg (Config config) =
    Config { config | onMousedown = Just msg }


onMouseleave : msg -> Config msg -> Config msg
onMouseleave msg (Config config) =
    Config { config | onMouseleave = Just msg }


truncateWidth : Float -> Config msg -> Config msg
truncateWidth width (Config config) =
    Config { config | truncationWidth = Just width }


view : Config msg -> String -> Html msg
view (Config config) value =
    div
        -- root
        [ StyledAttribs.css
            [ Css.fontSize (Css.rem 0.875)
            , Css.fontWeight (Css.int 400)

            -- , Css.letterSpacing Css.normal
            , Css.color (Css.hex "#35374A")
            , Css.display Css.inlineBlock
            , Css.border3 (Css.px 2) Css.solid Css.transparent
            , Css.borderRadius (Css.px 16)
            , Css.padding2 (Css.px 0) (Css.px 9.6)
            , Css.boxSizing Css.borderBox
            , Css.backgroundColor (Css.hex "#E1E2EA")
            , Css.hover [ Css.borderColor (Css.hex "#C4C5D4") ]
            , Css.height (Css.px 30)
            ]
        ]
        [ div
            -- layoutContainer
            [ StyledAttribs.css
                [ Css.height (Css.pct 100), Css.displayFlex, Css.alignItems Css.center ]
            ]
            [ viewTextContent config value
            , viewClear config
            ]
        ]


viewTextContent : Configuration msg -> String -> Html msg
viewTextContent config value =
    let
        resolveTruncation =
            case config.truncationWidth of
                Just width ->
                    [ Css.textOverflow Css.ellipsis
                    , Css.overflowX Css.hidden
                    , Css.whiteSpace Css.noWrap
                    , Css.maxWidth (Css.px width)
                    ]

                Nothing ->
                    []
    in
    span
        -- truncate
        [ StyledAttribs.css
            ([ Css.marginTop (Css.px -1) ]
                ++ resolveTruncation
            )
        ]
        [ text value ]


viewClear : Configuration msg -> Html msg
viewClear config =
    let
        dismiss onDismissMsg =
            onClick onDismissMsg

        mousedown onMousedownMsg =
            on "mousedown" <| Decode.succeed onMousedownMsg

        mouseleave onMouseleaveMsg =
            on "mouseleave" <| Decode.succeed onMouseleaveMsg

        events =
            List.filterMap identity
                [ Maybe.map dismiss config.onDismiss
                , Maybe.map mousedown config.onMousedown
                , Maybe.map mouseleave config.onMouseleave
                ]
    in
    span
        -- dismissIcon
        ([ StyledAttribs.css
            [ Css.position Css.relative
            , Css.displayFlex
            , Css.height (Css.pct 100)
            , Css.alignItems Css.center
            , Css.padding2 (Css.px 0) (Css.rem 0.375)
            , Css.marginRight (Css.rem -0.6625)
            , Css.marginLeft (Css.rem -0.225)
            , Css.color (Css.hex "#6B6E94")
            , Css.cursor Css.pointer
            , Css.hover [ Css.color (Css.hex "#4B4D68") ]
            ]
         ]
            ++ events
        )
        [ -- Add svg stuff here
          span
            [ -- background
              StyledAttribs.css
                [ Css.position Css.absolute
                , Css.display Css.inlineBlock
                , Css.width (Css.px 8)
                , Css.height (Css.px 8)
                , Css.backgroundColor (Css.hex "#FFFFFF")
                , Css.left (Css.px 10)
                , Css.top (Css.px 9)
                ]
            ]
            []
        , div [ StyledAttribs.css [ Css.height (Css.px 16), Css.width (Css.px 16), Css.zIndex (Css.int 1) ] ] [ ClearIcon.view ]
        ]