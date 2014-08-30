BeaconParty
===========

```
schedule-object ::=
                        {
                            "schedule" : schedule-spec
                        }

schedule-spec ::=
                        {    "uuid"  : string
                            ,"major" : integer
                            ,"minor" : integer
                            ,"sequence" : sequence-spec
                        }

sequence-spec ::=
                        {
                            "time in seconds from epoch" : action-spec
                            [,"time in seconds from epoch" : action-spec]
                        }
       
action-spec ::= 
                        {
                            screen-color-spec |
                            url-spec |
                            play-sound-spec |
                            flash-spec
                        }  
                         
screen-color-spec ::=
                        { 
                            "action": "screen color"
                            ,"r": integer
                            ,"g": integer
                            ,"b" : integer
                            [,"frequency": float]
                        } 

url-spec ::=
                        { 
                             "action": "url"
                            ,"url": string
                        }

play-sound-spec ::= 
                        {
                              "action": "sound"
                             ,"loop": boolean
                            [,"local-file": string | "url" : string]
                        }

flash-spec ::=
                        {
                             "action":"flash"
                            ,"frequency": float
                            [,"brightness": integer]
                        }

vibrate-spec ::= 
                        {
                            "frequency": float
                        }
```