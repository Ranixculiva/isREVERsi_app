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
    var description: String{
        get{
            switch type{
            case .win:
                return UI.Texts.win
            case .getPoints:
                let points = parameters.getPoints.points
                return String(format: UI.Texts.getPoints, points)
                //self.parameters.getPoints.points = points
            case .winTheComputerByPoints:
                let byPoints = parameters.winTheComputerByPoints.byPoints
                return String(format: UI.Texts.winTheComputerByPoints, byPoints)
                //self.parameters.winTheComputerByPoints.byPoints = byPoints
            }
        }
    }
    enum key: String{
        case sharedChallenge = "shareChallenge"
    }
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
    class func getTheNumberOfCompletedChallenge(gameSize: Int, isColorWhite: Bool, level: Int, difficulty: difficultyType) -> Int{
        let challenges = Challenge.sharedChallenge(gameSize: gameSize, isColorWhite: isColorWhite, level: level, difficulty: difficulty)
        var number = 0
        for challenge in challenges{
            if challenge.isCompleted{
                number += 1
            }
        }
        return number
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
        case .getPoints:
            self.parameters.getPoints.points = parameters[0] as! Int
        case .winTheComputerByPoints:
            self.parameters.winTheComputerByPoints.byPoints = parameters[0] as! Int
        default:
            break
        }
    }
    static func saveSharedChallenge(){
        //save with JSONEncoder
//        let filemanager = FileManager()
//        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let path = URL.appendingPathComponent("challenges.dat")
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(sharedChallenge) else {
            print("saving challeges failed")
            return
        }
        //try? data.write(to: path)
        KeychainWrapper.standard.set(data, forKey: key.sharedChallenge.rawValue)
    }
    static func loadSharedChallenge(){
//        let filemanager = FileManager()
//        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let path = URL.appendingPathComponent("challenges.dat")
        let decoder = JSONDecoder()
        
        guard let data = KeychainWrapper.standard.data(forKey: key.sharedChallenge.rawValue) else {return}
        
        guard let sharedAchievement = try? decoder.decode([[[[[Challenge]]]]].self, from: data) else{return}
        
        self.sharedChallenge = sharedAchievement
    }
}
