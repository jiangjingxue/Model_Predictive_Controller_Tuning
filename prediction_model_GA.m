function [A,B,C] = prediction_model_GA(vk,thetak,dT)
    A = [1 0 -vk*sin(thetak)*dT;
         0 1 vk*cos(thetak)*dT;
         0 0 1
        ];
    B = [cos(thetak)*dT 0;
         sin(thetak)*dT 0;
         0 dT
        ];
    C = [1 0 0;
         0 1 0;
         0 0 1
        ];

end 