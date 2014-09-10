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
                            [,"rand": boolean] (If set delay is set to a random number bewteen 0 and the delay value.)
                            
                        } 

url-spec ::=
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "url"
                            ,"url": string
                        }

sound-spec ::= 
                        {
                             "executed":0
                             ,"time" : float in seconds from epoch
                             ,"action": "sound"
                             ,"loop": boolean
                            [,"local-file": string | "url" : string]
                            [,"duration":float]
                        }

flash-spec ::=
                        {   "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action":"flash"
                            ,"frequency": float
                           [,"brightness": float 0-1]
                           [,"delay": float]
                           [,"rand": boolean] (If set delay is set to a random number bewteen 0 and the delay value.)
                        }

stop-flash-spec ::=
                        {   "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action":"stop-flash"
                        }

vibrate-spec ::= 
                        {
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action":"vibrate"
                        }

twinkle-spec ::=        
                        {   "executed":0
                            ,"action":"twinkle"
                            ,"max-frequency": float
                           [,"inverse": boolean]
                           [,"offset": float]
                           [,"brightness": float 0-1]
                           [,"delay": float]
                           [,"rand": boolean] (If set delay is set to a random number bewteen 0 and the delay value.)
                        }

rainbow-spec ::=
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "rainbow"
                            [,"frequency": float]
                            [,"delay": float]
                            [,"rand": boolean] (If set delay is set to a random number bewteen 0 and the delay value.)
                            
                        } 
```
