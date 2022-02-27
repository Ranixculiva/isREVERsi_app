//
//  BMP.hpp
//  BMPtest
//
//  Created by john gospai on 2019/10/12.
//

#ifndef BMP_H
#define BMP_H

#include <bitset>
#include <fstream>
#include <iostream>
#include <cstdint>
#include <string>
#include <vector>

using namespace std;

struct Color
{
    int R, G, B;
};

class BMP
{
public:
    BMP(string inName)
    {
        _inName = inName;
        fstream fin(inName, ios::in | ios::binary);
        if (!fin)
            cout << "\nError: There is no file named " << inName << "!\n\n";
        else
        {
            for (int i = 0; i < 54; i++)
            {
                fin >> header[i];
                bitset<8> x(header[i]);
                cout << i << ": " << x
                    << ", " << int(header[i]) << endl;
            }
            width_u = *(uint32_t*)(header + 18);
            height_u = *(uint32_t*)(header + 22);
            width = int(width_u);
            height = int(height_u);

            /*width = 512;
            height = 512;*/
            
            cout << "\nReading header completed, image width = " << width << ", height = " << height << ".\n";
            
            vector<vector<Color>> _imageVec(width, vector<Color>(height));
            for (size_t y = 0; y != _imageVec.size(); ++y)
                for (size_t x = 0; x != _imageVec[0].size(); ++x)
                {
                    char chR, chG, chB;
                    fin.get(chB).get(chG).get(chR);
                    _imageVec[y][x].B = chB;
                    _imageVec[y][x].G = chG;
                    _imageVec[y][x].R = chR;
                }

            imageVec = _imageVec;
            fin.close();
            cout << "Reading BMP image completed, input file name: " << _inName << ".\n";
        }
    }

    void Rotate270()
    {
        vector<vector<Color>> _imageVec(height, vector<Color>(width));
        for (size_t y = 0; y != _imageVec.size(); ++y)
            for (size_t x = 0; x != _imageVec[0].size(); ++x)
            {
                _imageVec[y][x].B = imageVec[_imageVec[0].size()-x-1][y].B;
                _imageVec[y][x].G = imageVec[_imageVec[0].size()-x-1][y].G;
                _imageVec[y][x].R = imageVec[_imageVec[0].size()-x-1][y].R;
            }
        imageVec = _imageVec;
        uint8_t tmp = header[18];
        header[18] = header[22];
        header[22] = tmp;
        cout << "Rotate completed!\n\n";
    }

    void ChannelChange()
    {
        string c1, c2;
        int tmp;
        cout << "Please enter color 1, R, G or B): ";
        cin >> c1;
        cout << "Please enter color 2, R, G or B): ";
        cin >> c2;
        if ((c1=="R"&&c2=="G") || (c1=="G"&&c2=="R"))
            for (size_t y = 0; y != imageVec.size(); ++y)
                for (size_t x = 0; x != imageVec[0].size(); ++x)
                {
                    tmp = imageVec[y][x].R;
                    imageVec[y][x].R = imageVec[y][x].G;
                    imageVec[y][x].G = tmp;
                }
        else if ((c1=="B"&&c2=="G") || (c1=="G"&&c2=="B"))
            for (size_t y = 0; y != imageVec.size(); ++y)
                for (size_t x = 0; x != imageVec[0].size(); ++x)
                {
                    tmp = imageVec[y][x].B;
                    imageVec[y][x].B = imageVec[y][x].G;
                    imageVec[y][x].G = tmp;
                }
        else if ((c1=="B"&&c2=="R") || (c1=="R"&&c2=="B"))
            for (size_t y = 0; y != imageVec.size(); ++y)
                for (size_t x = 0; x != imageVec[0].size(); ++x)
                {
                    tmp = imageVec[y][x].B;
                    imageVec[y][x].B = imageVec[y][x].R;
                    imageVec[y][x].R = tmp;
                }
        cout << "Channel interchange completed!\n\n";
    }

    void Write()
    {
        string outName;
        cout << "Please enter the output file name incluing .bmp:\n";
        cin >> outName;
        fstream fout(outName, ios::out | ios::binary);
        for (int i = 0; i < 54; i++)
            fout << header[i];
        for (size_t y=0; y!=imageVec.size(); ++y)
            for (size_t x = 0; x != imageVec[0].size(); ++x)
            {
                char chB = imageVec[y][x].B;
                char chG = imageVec[y][x].G;
                char chR = imageVec[y][x].R;
                fout.put(chB).put(chG).put(chR);
            }
        fout.close();
        cout << "\nWriting BMP image completed, output file name: " << outName << ".\n\n";
    }

    
private:
    string _inName;
    uint32_t width_u;
    uint32_t height_u;
    int width;
    int height;
    uint8_t header[54];
    vector<vector<Color>> imageVec;
};

#endif
