(* ::Package:: *)

(* ::Input:: *)
(*Exit[]*)


(* ::Title:: *)
(*Instructions*)


(* ::ItemNumbered:: *)
(*Press shift+enter at the Exit[] command above before starting.*)


(* ::ItemNumbered:: *)
(*Ignore the code below BUT*)


(* ::ItemNumbered:: *)
(*Always press shift+enter in the code line below to make sure you are using the correct example (running some code will change the output of OTHER code).*)


(* ::ItemNumbered:: *)
(*Use pencil and paper to work the problem by yourself whenever possible.*)


(* ::ItemNumbered:: *)
(*Please! Report any typos to me. *)


(* ::Title:: *)
(*PPF*)


(* ::Text:: *)
(*The controls below allow you to choose the level of capital and labor used by the clothing industry (good in the x-axis). The residual capital and labor is used by the food industry (good in the y-axis).*)


(* ::Input:: *)
(*Manipulate[Column[{Style["PPF (declining MPs)",Bold],Style["Quantity of clothing: "<>ToString[N[c[K,L]],TraditionalForm]],Style["Quantity of food: "<>ToString[N[f[200-K,200-L]],TraditionalForm]],*)
(*Style["\!\(\*FractionBox[SubscriptBox[\(MP\), \(K\)], SubscriptBox[\(MP\), \(L\)]]\) for clothing = "<>ToString[N[ck[k,l]/cl[k,l]/.{k->K,l->L}],TraditionalForm]],Style["\!\(\*FractionBox[SubscriptBox[\(MP\), \(K\)], SubscriptBox[\(MP\), \(L\)]]\) for food = "<>ToString[N[fk[k,l]/fl[k,l]/.{k->200-K,l->200-L}],TraditionalForm]],p1=ParametricPlot[{c[k,l],f[200-k,200-l]},{k,0,199},{l,0,199},FrameLabel->{"clothing","food"},AspectRatio->1,ImageSize->Medium];p2=Graphics[Point[{c[K,L],f[200-K,200-L]}]];Show[p1,p2]}],(*Controls*) {K,1,199,1},{L,1,199,1},(*Options for Manipulate*)Initialization:>{c[k_,l_]:=Sqrt[k*l], f[k_,l_]:=Sqrt[k]+2*Sqrt[l],ck[k_,l_]:=D[c[k,l],k],cl[k_,l_]:=D[c[k,l],l],fk[k_,l_]:=D[f[k,l],k],fl[k_,l_]:=D[f[k,l],l]}]*)


(* ::Input:: *)
(*Exit[]*)


(* ::Input:: *)
(*Manipulate[Column[{Style["PPF (constant MPs)",Bold],Style["Quantity of clothing: "<>ToString[N[c2[K,L]],TraditionalForm]],Style["Quantity of food: "<>ToString[N[f2[200-K,200-L]],TraditionalForm]],*)
(*Style["\!\(\*FractionBox[SubscriptBox[\(MP\), \(K\)], SubscriptBox[\(MP\), \(L\)]]\) for clothing = "<>ToString[N[ck2[k,l]/cl2[k,l]/.{k->K,l->L}],TraditionalForm]],Style["\!\(\*FractionBox[SubscriptBox[\(MP\), \(K\)], SubscriptBox[\(MP\), \(L\)]]\) for food = "<>ToString[N[fk2[k,l]/fl2[k,l]/.{k->200-K,l->200-L}],TraditionalForm]],p1=ParametricPlot[{c2[k,l],f2[200-k,200-l]},{k,0,199},{l,0,199},FrameLabel->{"clothing","food"},AspectRatio->1,ImageSize->Medium];p2=Graphics[Point[{c2[K,L],f2[200-K,200-L]}]];Show[p1,p2]}],(*Controls*) {K,1,199,1},{L,1,199,1},(*Options for Manipulate*)Initialization:>{c2[k_,l_]:=2*k+l, f2[k_,l_]:=k+2*l,ck2[k_,l_]:=D[c[k,l],k],cl2[k_,l_]:=D[c[k,l],l],fk2[k_,l_]:=D[f[k,l],k],fl2[k_,l_]:=D[f[k,l],l]}]*)


(* ::Input:: *)
(*Exit[]*)
