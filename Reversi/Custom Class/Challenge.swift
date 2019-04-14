//
//  Acheievement.swift
//  Reversi
//
//  Created by john gospai on 2019/2/8.
//  Copyright © 2019 john gospai. All rights reserved.
//

import Foundation
class Challenge: Codable{
    enum difficultyType: Int, Codable{
        case easy = 0, normal, hard
    }
    enum challengeType: Int, Codable{
        case winTheComputerByPoints = 0,
        win,
        getPoints
    }
    var type: challengeType
    var level: Int
    var gameSize: Int
    var difficulty: difficultyType
    var description: String
    //parameters for getPoints
    fileprivate var parameters = Parameters()
    fileprivate struct Parameters: Codable{
        var getPoints = GetPoints()
        var winTheComputerByPoints = WinTheComputerByPoints()
        fileprivate struct GetPoints: Codable{
            var points = 0
        }
        fileprivate struct WinTheComputerByPoints: Codable {
            var byPoints = 0
        }
    }
    
    var isCompleted = false{
        willSet(newValue){
            canGetOneFlip = false
            if !isCompleted, newValue{
                canGetOneFlip = true
            }
        }
    }
    var canGetOneFlip = false
    fileprivate static var sharedChallenge =
        [   //gameSize 4x4
            [   //white
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 3
                    [   //easy
                        [Challenge(gameSize: 4, level: 3, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 3, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 3, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 3, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 3, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 3, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 3, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 3, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 3, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ]
                ],
                //black
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .getPoints, 9),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 1)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .getPoints, 9),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 1)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .getPoints, 9),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 1)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 3
                    [   //easy
                        [Challenge(gameSize: 4, level: 3, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 3, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 3, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 3, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 3, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 3, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 3, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 3, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 3, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ]
                ]
            ],
            //gameSize 6x6
            [   //white
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 3
                    [   //easy
                        [Challenge(gameSize: 6, level: 3, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 3, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 3, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 6, level: 3, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 3, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 3, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 6, level: 3, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 3, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 3, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ]
                ],
                //black
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 3
                    [   //easy
                        [Challenge(gameSize: 6, level: 3, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 3, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 3, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 6, level: 3, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 3, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 3, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 6, level: 3, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 3, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 6, level: 3, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ]
                ]
            ],
            //gameSize 8x8
            [   //white
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 3
                    [   //easy
                        [Challenge(gameSize: 8, level: 3, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 3, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 3, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 3, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 3, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 3, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 3, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 3, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 3, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ]
                ],
                //black
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ],
                    //level 3
                    [   //easy
                        [Challenge(gameSize: 8, level: 3, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 3, difficulty: .easy, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 3, difficulty: .easy, type: .winTheComputerByPoints, 15)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 3, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 3, difficulty: .normal, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 3, difficulty: .normal, type: .winTheComputerByPoints, 15)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 3, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 3, difficulty: .hard, type: .getPoints, 15),
                         Challenge(gameSize: 8, level: 3, difficulty: .hard, type: .winTheComputerByPoints, 15)
                        ]
                    ]
                ]
            ]
        ]
    class func sharedChallenge(gameSize: Int, isColorWhite: Bool, level: Int, difficulty: difficultyType) -> [Challenge]{
        let gameSizeIndex = gameSize / 2 - 2
        return Challenge.sharedChallenge[gameSizeIndex][isColorWhite ? 0 : 1][level - 1][difficulty.rawValue]
    }
    func getChallengeParametersForGetPoints() -> Int{
        if type != .getPoints {fatalError("wrong type")}
        return parameters.getPoints.points
    }
    func getChallengeParametersForWinTheComputerByPoints() -> Int{
        if type != .winTheComputerByPoints {fatalError("wrong type")}
        return parameters.winTheComputerByPoints.byPoints
    }
    class func resetSharedChallengeCanGetOneFlip(challenges: [Challenge]){
        for challenge in challenges{
            challenge.canGetOneFlip = false
        }
    }
    fileprivate init<T: Codable>(gameSize: Int, level: Int, difficulty: difficultyType, type: challengeType, _ parameters: T...){
        self.level = level
        self.difficulty = difficulty
        self.gameSize = gameSize
        self.type = type
        switch type{
        case .win:
            self.description = "win".localized()
        case .getPoints:
            guard let points = parameters[0] as? Int else{fatalError("wrong parameters.")}
            self.description = String(format: "getPoints".localized(), points)
            self.parameters.getPoints.points = points
        case .winTheComputerByPoints:
            guard let byPoints = parameters[0] as? Int else{fatalError("wrong parameters.")}
            self.description = String(format: "winTheComputerByPoints".localized(), byPoints)
            self.parameters.winTheComputerByPoints.byPoints = byPoints
        }
    }
    static func saveSharedChallenge(){
        //save with JSONEncoder
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = URL.appendingPathComponent("challenges.dat")
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(sharedChallenge) else {
            print("saving challeges failed")
            return
        }
        try? data.write(to: path)
    }
    static func loadSharedChallenge(){
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = URL.appendingPathComponent("challenges.dat")
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: path) else {return}
        guard let sharedAchievement = try? decoder.decode([[[[[Challenge]]]]].self, from: data) else{return}
        self.sharedChallenge = sharedAchievement
    }
}
