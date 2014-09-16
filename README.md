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
                            [,"brightness": float 0-1]
                            
                        } 
stop-spec :: =          {
                            "executed":0
                            ,"time":float in seconds from epoch
                            ,"action":"stop"
                        }

url-spec ::=
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "url"
                            ,"url": string
                        }
                        
stop-url-spec :: = 
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "stop-url"
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

stop-sound-spec ::= 
                        {
                             "executed":0
                             ,"time" : float in seconds from epoch
                             ,"action": "stop-sound"
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
                            [,"brightness": float 0-1]
                        } 
particle-spec ::=
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "particle"
                        }
stop-particle-spec ::=
                        { 
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "stop-particle"
                        }
                                                                        
stop-all ::=            {
                            "executed":0
                            ,"time" : float in seconds from epoch
                            ,"action": "stop-all"
                        }
```

Examples
--------

```
[
      {
          "uuid":"BF5094D9-5849-47ED-8FA1-983A748A9586"
          ,"major":1
          ,"minor":8
          ,"sequence":
          [
           {
           "executed":0
           ,"time":0
           ,"action": "color"
           ,"r1": 0
           ,"g1": 0
           ,"b1" : 0
           ,"a1" : 1
           ,"r2": 1
           ,"g2": 1
           ,"b2" : 1
           ,"a2" : 1
           ,"brightness":1
           }
           ,{
           "executed":0
           ,"time" : 5
           ,"action": "color"
           ,"r1": 0
           ,"g1": 1
           ,"b1" : 1
           ,"a1" : 1
           ,"r2": 1
           ,"g2": 0
           ,"b2" : 1
           ,"a2" : 1
           ,"brightness":0.8
           ,"frequency": 20
           ,"delay": 5
           ,"rand": true
           }
           ,{
           "executed":0
           ,"time" : 10
           ,"action": "stop"
           }
           ,{
           "executed":0
           ,"time" : 10
           ,"action": "url"
           ,"url": "http://ziggy.is"
           }
           ,{
           "executed":0
           ,"time" : 15
           ,"action": "sound"
           ,"loop": true
           ,"local-file": "laugh.caf"
           }
           ,{
           "executed":0
           ,"time" : 20
           ,"action": "sound"
           ,"loop": true
           ,"url": "http://omdesignllc.com/Hey-that-polio-es-loco-[CHUCKLES].mp3"
           }
           ,{   "executed":0
           ,"time" : 30
           ,"action":"flash"
           ,"frequency": 10
           ,"brightness": 0.5
           }
           ,{   "executed":0
           ,"time" : 35
           ,"action":"flash"
           ,"frequency": 20
           ,"rand": true
           }
           ,{   "executed":0
           ,"time" : 45
           ,"action":"flash"
           ,"frequency": 2
           ,"brightness": 0.1
           ,"delay": 2
           }
           ,{   "executed":0
           ,"time" : 50
           ,"action":"flash"
           ,"frequency": 40
           ,"brightness": 0.8
           ,"delay": 4
           ,"rand": true
           }
           ,{   "executed":0
           ,"time" : 55
           ,"action":"stop-flash"
           }
           ,{
           "executed":0
           ,"time" : 55
           ,"action":"vibrate"
           }
           ,{   "executed":0
           ,"time" : 60
           ,"action":"twinkle"
           ,"max-frequency": 10
           ,"brightness": 0.5
           }
           ,{   "executed":0
           ,"time" : 65
           ,"action":"twinkle"
           ,"max-frequency": 20
           ,"rand": true
           }
           ,{   "executed":0
           ,"time" : 70
           ,"action":"twinkle"
           ,"max-frequency": 2
           ,"brightness": 0.1
           ,"delay": 2
           }
           ,{   "executed":0
           ,"time" : 75
           ,"action":"twinkle"
           ,"max-frequency": 40
           ,"brightness": 0.8
           ,"delay": 2
           ,"rand": true
           },{
            "executed":0
            ,"time":79
            ,"action":"stop-url"
           }
           ,{
           "executed":0
           ,"time":80
           ,"action": "rainbow"
           ,"r1": 0
           ,"g1": 0
           ,"b1" : 0
           ,"a1" : 1
           ,"r2": 1
           ,"g2": 1
           ,"b2" : 1
           ,"a2" : 1
           ,"brightness":1
           }
           ,{
           "executed":0
           ,"time" : 85
           ,"action": "rainbow"
           ,"r1": 0
           ,"g1": 1
           ,"b1" : 1
           ,"a1" : 1
           ,"r2": 1
           ,"g2": 0
           ,"b2" : 1
           ,"a2" : 1
           ,"brightness":0.8
           ,"frequency": 20
           ,"delay": 5
           ,"rand": true
           }
           ,{
           "executed":0
           ,"time" : 90
           ,"action": "stop-all"
           }
        ]
    }
]
```

```
[
      {
          "uuid":"BF5094D9-5849-47ED-8FA1-983A748A9586"
          ,"major":1
          ,"minor":8
          ,"sequence":
          [
           ,{   "executed":0
           ,"time" : 0
           ,"action":"twinkle"
           ,"max-frequency": 40
           ,"brightness": 0.8
           ,"delay": 2
           ,"rand": true
           }
           
        ]
    }
]
```
