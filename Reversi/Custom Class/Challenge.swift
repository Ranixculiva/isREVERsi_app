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
    static var areAllChallengesCompleted: Bool{
        return sharedChallenge.allSatisfy{
            $0.allSatisfy{
                $0.allSatisfy{
                    $0.allSatisfy{
                        $0.allSatisfy{
                            $0.isCompleted
                        }
                    }
                }
            }
        }
    }
    fileprivate static var sharedChallengeTemplate =
        [   //MARK: gameSize 4x4
            [   //MARK: white
                [   //MARK: level 1
                    [   //MARK: easy
                        [Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 15),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .getPoints, 16)
                        ],
                        //MARK: normal
                        [Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 18),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .getPoints, 18)
                        ],
                        //MARK: hard
                        [Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 14),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .getPoints, 15)
                        ]
                    ],
                    //MARK: level 2
                    [   //MARK: easy
                        [Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 13),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .getPoints, 14)
                        ],
                        //MARK: normal
                        [Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 14),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .getPoints, 14)
                        ],
                        //MARK: hard
                        [Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 14),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .getPoints, 14)
                        ]
                    ]
                ],
                //MARK: MARK: black
                [   //MARK: MARK: level 1
                    [   //MARK: MARK: easy
                        [Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 1),
                         Challenge(gameSize: 4, level: 1, difficulty: .easy, type: .getPoints, 9)
                        ],
                        //MARK: MARK: normal
                        [Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 1),
                         Challenge(gameSize: 4, level: 1, difficulty: .normal, type: .getPoints, 9)
                        ],
                        //MARK: MARK: hard
                        [Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 3),
                         Challenge(gameSize: 4, level: 1, difficulty: .hard, type: .getPoints, 9)
                        ]
                    ],
                    //MARK: MARK: level 2
                    [   //MARK: MARK: easy
                        [Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 11),
                         Challenge(gameSize: 4, level: 2, difficulty: .easy, type: .getPoints, 12)
                        ],
                        //MARK: MARK: normal
                        [Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .normal, type: .getPoints, 16)
                        ],
                        //MARK: MARK: hard
                        [Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 15),
                         Challenge(gameSize: 4, level: 2, difficulty: .hard, type: .getPoints, 16)
                        ]
                    ]
                ]
            ],
            //MARK: gameSize 6x6
            [   //MARK: white
                [   //MARK: level 1
                    [   //MARK: easy
                        [Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 56),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .getPoints, 60)
                        ],
                        //MARK: normal
                        [Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 19),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .getPoints, 40)
                        ],
                        //MARK: hard
                        [Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 47),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .getPoints, 59)
                        ]
                    ],
                    //MARK: level 2
                    [   //MARK: easy
                        [Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 51),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .getPoints, 51)
                        ],
                        //MARK: normal
                        [Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 55),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .getPoints, 55)
                        ],
                        //MARK: hard
                        [Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 52),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .getPoints, 52)
                        ]
                    ]
                ],
                //MARK: black
                [   //MARK: level 1
                    [   //MARK: easy
                        [Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 19),
                         Challenge(gameSize: 6, level: 1, difficulty: .easy, type: .getPoints, 41)
                        ],
                        //MARK: normal
                        [Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 16),
                         Challenge(gameSize: 6, level: 1, difficulty: .normal, type: .getPoints, 36)
                        ],
                        //MARK: hard
                        [Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 18),
                         Challenge(gameSize: 6, level: 1, difficulty: .hard, type: .getPoints, 40)
                        ]
                    ],
                    //MARK: level 2
                    [   //MARK: easy
                        [Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 40),
                         Challenge(gameSize: 6, level: 2, difficulty: .easy, type: .getPoints, 48)
                        ],
                        //MARK: normal
                        [Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 42),
                         Challenge(gameSize: 6, level: 2, difficulty: .normal, type: .getPoints, 51)
                        ],
                        //MARK: hard
                        [Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 48),
                         Challenge(gameSize: 6, level: 2, difficulty: .hard, type: .getPoints, 51)
                        ]
                    ]
                ]
            ],
            //gameSize 8x8
            [   //white
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 56),
                         Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .getPoints, 101)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 58),
                         Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .getPoints, 95)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 121),
                         Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .getPoints, 125)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 124),
                         Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .getPoints, 124)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 98),
                         Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .getPoints, 103)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 105),
                         Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .getPoints, 105)
                        ]
                    ]
                ],
                //black
                [   //level 1
                    [   //easy
                        [Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .winTheComputerByPoints, 75),
                         Challenge(gameSize: 8, level: 1, difficulty: .easy, type: .getPoints, 108)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .winTheComputerByPoints, 51),
                         Challenge(gameSize: 8, level: 1, difficulty: .normal, type: .getPoints, 94)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .winTheComputerByPoints, 27),
                         Challenge(gameSize: 8, level: 1, difficulty: .hard, type: .getPoints, 72)
                        ]
                    ],
                    //level 2
                    [   //easy
                        [Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .winTheComputerByPoints, 111),
                         Challenge(gameSize: 8, level: 2, difficulty: .easy, type: .getPoints, 134)
                        ],
                        //normal
                        [Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .winTheComputerByPoints, 93),
                         Challenge(gameSize: 8, level: 2, difficulty: .normal, type: .getPoints, 101)
                        ],
                        //hard
                        [Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .win, 0),
                         Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .winTheComputerByPoints, 105),
                         Challenge(gameSize: 8, level: 2, difficulty: .hard, type: .getPoints, 105)
                        ]
                    ]
                ]
            ]
        ]
    fileprivate static var sharedChallenge = sharedChallengeTemplate
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
        updateShaerdThreshold()
    }
    static func updateShaerdThreshold(){
        for (g, gameSize) in sharedChallenge.enumerated(){
            for (co,color) in gameSize.enumerated(){
                while sharedChallenge[g][co].count != sharedChallengeTemplate[g][co].count{
                    if sharedChallenge[g][co].count > sharedChallengeTemplate[g][co].count{
                        sharedChallenge[g][co].removeLast(1)
                    }else if sharedChallenge[g][co].count < sharedChallengeTemplate[g][co].count{
                        sharedChallenge[g][co].append(sharedChallengeTemplate[g][co][0])
                    }
                }
                for (l,level) in sharedChallenge[g][co].enumerated(){
                    for (d,difficulty) in level.enumerated(){
                        for c1 in 0...difficulty.count-1{
                            for c2 in 0...sharedChallengeTemplate[g][co][l][d].count-1{
                                if sharedChallenge[g][co][l][d][c1].type == sharedChallengeTemplate[g][co][l][d][c2].type{
                                    sharedChallenge[g][co][l][d][c1].parameters = sharedChallengeTemplate[g][co][l][d][c2].parameters
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
