BeaconParty
===========

```
schedule-object ::=
                        [ 
                              schedule-spec1
                            [,schedule-spec2]
                            [,schedule-specn]
                        ]

schedule-spec ::=
                        {    "uuid"  : string
                            ,"major" : integer
                            ,"minor" : integer
                            ,"sequence" : sequence-spec
                        }

sequence-spec ::=
                        [
                              action-spec1
                            [,action-spec2]
                            [,action-specn]
                        ]
       
action-spec ::= 
                            screen-color-spec |
                            stop-spec|
                            url-spec |
                            sound-spec |
                            flash-spec |
                            vibrate-spec

                         
screen-color-spec ::=
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "color"
                            ,"r1": float
                            ,"g1": float
                            ,"b1" : float
                            ,"a1" : float
                            ,"r2": float
                            ,"g2": float
                            ,"b2" : float
                            ,"a2" : float
                            [,"frequency": float]
                            [,"delay": float]
                            
                        } 

url-spec ::=
                        { 
                            "executed":0
                            ,"action": "url"
                            ,"url": string
                        }

sound-spec ::= 
                        {
                             "executed":0
                             ,"action": "sound"
                             ,"loop": boolean
                            [,"local-file": string | "url" : string]
                        }

flash-spec ::=
                        {   "executed":0
                            ,"action":"flash"
                            ,"frequency": float
                           [,"brightness": float 0-1]
                        }

stop-flash-spec ::=
                        {   "executed":0
                            ,"action":"stop-flash"
                        }

vibrate-spec ::= 
                        {
                            "executed":0
                            "action":"vibrate"
                        }
```