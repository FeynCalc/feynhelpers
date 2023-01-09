(* ::Package:: *)

(* :Title: UVCheck                                                    *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2023 Rolf Mertig
	Copyright (C) 1997-2023 Frederik Orellana
	Copyright (C) 2014-2023 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the UV-parts of Passarino-Veltman
	B (up to rank 10), C (up to rank 9) and D (up to rank 8) functions.  *)

(* ------------------------------------------------------------------------ *)



(* ::Section:: *)
(*Load FeynCalc and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the UV-parts of Passarino-Veltman B (up to rank 10), C (up to rank 9) and D (up to rank 8) functions"];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadAddOns= {"FeynHelpers"};
<<FeynCalc`;


(* ::Text:: *)
(*The most complete collection of results for these functions is available in hep-ph/0609282 by G.Sulyok. Here we first copy the results from there*)
(*and then show that they agree with what we obtain using Package-X via FeynHelpers.*)


(* ::Section::Closed:: *)
(*UV parts of B-functions up to rank 10*)


resultsSulyokB={
(* B0, B1, B00, B11 *)
uvPart[PaVe[0,{SPD[p1,p1]},{m0^2,m1^2}]]->-2/(D-4),
uvPart[PaVe[1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4),

uvPart[PaVe[0,0,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/6)(-3m0^2-3m1^2+SPD[p1,p1]),
uvPart[PaVe[1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(-2/3),

(* B001, B111 *)
uvPart[PaVe[0,0,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/12)(2m0^2+4m1^2-SPD[p1,p1]),
uvPart[PaVe[1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/2),

(* B0000, B0011, B1111 *)
uvPart[PaVe[0,0,0,0,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/120)(-10 m0^4-10 m1^4+5m1^2 SPD[p1,p1]-SPD[p1,p1]^2+5 m0^2(-2m1^2+SPD[p1,p1])),
uvPart[PaVe[0,0,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/60)(-5 m0^2+3(-5m1^2+SPD[p1,p1])),
uvPart[PaVe[1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(-2/5),

(* B00001, B00111, B11111 *)
uvPart[PaVe[0,0,0,0,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/240)(5m0^4+15m1^4-6m1^2 SPD[p1,p1]+SPD[p1,p1]^2+2m0^2(5m1^2-2 SPD[p1,p1])),
uvPart[PaVe[0,0,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/60)(3m0^2+12m1^2-2 SPD[p1,p1]),

uvPart[PaVe[1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/3),
(* B000000, B000011, B001111, B111111 *)
uvPart[PaVe[0,0,0,0,0,0,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)((1/3360)(-35 m0^6-35m1^6+21 m1^4 SPD[p1,p1]-7 m1^2 SPD[p1,p1]^2+SPD[p1,p1]^3)+
(1/3360)(-7 m0^4(5m1^2-3SPD[p1,p1])-7m0^2(5m1^4-4m1^2SPD[p1,p1]+SPD[p1,p1]^2))
),
uvPart[PaVe[0,0,0,0,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/840)(-7 m0^4+7m0^2(-3m1^2+SPD[p1,p1])-2(21m1^4-7m1^2 SPD[p1,p1]+SPD[p1,p1]^2)),

uvPart[PaVe[0,0,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/210)(-7 m0^2+5(-7m1^2+SPD[p1,p1])),

uvPart[PaVe[1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(-2/7),

(* B0000001, B0000111, B0011111, B1111111 *)

uvPart[PaVe[0,0,0,0,0,0,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(
(1/6720)(14 m0^6+56m1^6-28m1^4 SPD[p1,p1]+8m1^2 SPD[p1,p1]^2-SPD[p1,p1]^3)+
(1/6720)(14 m0^4(2m1^2-SPD[p1,p1])+m0^2(42m1^4-28 m1^2 SPD[p1,p1]+6 SPD[p1,p1]^2) )
),

uvPart[PaVe[0,0,0,0,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/3360)(14m0^4+8m0^2(7m1^2-2SPD[p1,p1])+5(28 m1^4-8 m1^2 SPD[p1,p1]+SPD[p1,p1]^2)),


uvPart[PaVe[0,0,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/168)(4m0^2+24 m1^2-3 SPD[p1,p1]),


uvPart[PaVe[1,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/4),

(* B00000000, B00000011, B00001111, B00111111, B11111111  *)


uvPart[PaVe[0,0,0,0,0,0,0,0,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(
(1/120960)(-126 m0^8-126 m1^8+84m1^6 SPD[p1,p1]-36 m1^4 SPD[p1,p1]^2+9m1^2 SPD[p1,p1]^3-SPD[p1,p1]^4)+
(1/120960)(-42 m0^6(3m1^2-2SPD[p1,p1])-18 m0^4(7m1^4-7m1^2SPD[p1,p1]+2 SPD[p1,p1]^2))+
(1/120960)(- 9 m0^2(14 m1^6-14 m1^4 SPD[p1,p1] + 6 m1^2 SPD[p1,p1]^2-SPD[p1,p1]^3))),

uvPart[PaVe[0,0,0,0,0,0,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(
(1/60480)(-42 m0^6-18 m0^4(7m1^2-3SPD[p1,p1]))+

(1/60480)(-9 m0^2(28 m1^4-16m1^2SPD[p1,p1]+3SPD[p1,p1]^2))+

(1/60480)(5(-84 m1^6+36m1^4 SPD[p1,p1]-9m1^2 SPD[p1,p1]^2+SPD[p1,p1]^3))
),

uvPart[PaVe[0,0,0,0,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/5040)(-12 m0^4+15 m0^2(-4 m1^2+SPD[p1,p1])-5(36m1^4-9 m1^2 SPD[p1,p1]+SPD[p1,p1]^2)),

uvPart[PaVe[0,0,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->
1/(D-4)(1/504)(-9 m0^2+7(-9m1^2+SPD[p1,p1])),

uvPart[PaVe[1,1,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->
1/(D-4)(-2/9),

(* B000000001, B000000111, B000011111, B001111111, B111111111  *)

uvPart[PaVe[0,0,0,0,0,0,0,0,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(

(1/241920)(42 m0^8+210m1^8-120 m1^6SPD[p1,p1]+45 m1^4 SPD[p1,p1]^2-10 m1^2 SPD[p1,p1]^3+SPD[p1,p1]^4)
+(1/241920)( 12 m0^6(7m1^2-4 SPD[p1,p1])+9 m0^4(14m1^4-12m1^2SPD[p1,p1]+3SPD[p1,p1]^2))
+(1/241920)(2m0^2(84m1^6-72m1^4 SPD[p1,p1]+27m1^2SPD[p1,p1]^2-4SPD[p1,p1]^3))
),

uvPart[PaVe[0,0,0,0,0,0,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(
(1/20160)(6m0^6+120m1^6-45m1^4 SPD[p1,p1]+10m1^2 SPD[p1,p1]^2-SPD[p1,p1]^3)
+(1/20160)(3m0^4(8m1^2-3 SPD[p1,p1])+5m0^2(12m1^4-6m1^2 SPD[p1,p1]+SPD[p1,p1]^2))
),

uvPart[PaVe[0,0,0,0,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/10080)(15m0^4+10m0^2(9m1^2-2 SPD[p1,p1])+7(45 m1^4-10 m1^2 SPD[p1,p1]+SPD[p1,p1]^2)),

uvPart[PaVe[0,0,1,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/360)(5m0^2+40m1^2-4SPD[p1,p1]),

uvPart[PaVe[1,1,1,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/5),

(* B0000000000, B0000000011, B0000001111,
B0000111111, B0011111111, B1111111111  *)

uvPart[PaVe[0,0,0,0,0,0,0,0,0,0,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(
(1/5322240)(-462m0^10-462m1^10+330m1^8 SPD[p1,p1]-165 m1^6 SPD[p1,p1]^2+55 m1^4 SPD[p1,p1]^3)

+(1/5322240)*
(-11m1^2 SPD[p1,p1]^4+SPD[p1,p1]^5-66 m0^8(7m1^2-5SPD[p1,p1]))

+(1/5322240)(-33m0^6(14m1^4-16m1^2 SPD[p1,p1]+5SPD[p1,p1]^2))

+(1/5322240)(-11m0^4(42 m1^6-54m1^4SPD[p1,p1]+27m1^2SPD[p1,p1]^2-5SPD[p1,p1]^3))

+(1/5322240)(-11m0^2( 42m1^8-48m1^6SPD[p1,p1]+27m1^4 SPD[p1,p1]^2-8m1^2 SPD[p1,p1]^3+SPD[p1,p1]^4))

),


uvPart[PaVe[0,0,0,0,0,0,0,0,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(
(1/1330560)(-66m0^8-99m0^6(2m1^2-SPD[p1,p1]))
+(1/1330560)(-33m0^4(12m1^4-9m1^2SPD[p1,p1]+2SPD[p1,p1]^2))
+(1/1330560)*
(-11m0^2(60m1^6-45m1^4SPD[p1,p1]+15 m1^2SPD[p1,p1]^2-2SPD[p1,p1]^3))
+(1/1330560)*
(-3(330m1^8-165m1^6SPD[p1,p1]+55m1^4SPD[p1,p1]^2-11m1^2 SPD[p1,p1]^3+SPD[p1,p1]^4))
),
uvPart[PaVe[0,0,0,0,0,0,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(

(1/221760)(-33m0^6-55m0^4(3m1^2-SPD[p1,p1]))
+(1/221760)(-11m0^2(45m1^4-20m1^2SPD[p1,p1]+3SPD[p1,p1]^2))

+(1/221760)(7(-165m1^6+55m1^4SPD[p1,p1]-11m1^2 SPD[p1,p1]^2+SPD[p1,p1]^3))
),
uvPart[PaVe[0,0,0,0,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/55440)(-55m0^4-77m0^2(5m1^2-SPD[p1,p1])-28(55m1^4-11m1^2SPD[p1,p1]+SPD[p1,p1]^2)),

uvPart[PaVe[0,0,1,1,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(1/990)(-11m0^2-99m1^2+9SPD[p1,p1]),

uvPart[PaVe[1,1,1,1,1,1,1,1,1,1,{SPD[p1,p1]},{m0^2,m1^2}]]->1/(D-4)(-2/11)
};


(* ::Section::Closed:: *)
(*UV parts of C-functions up to rank 9*)


resultsSulyokC={
(*C1, C2*)
uvPart[PaVe[1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,



(* C00, C11, C12, C22 *)
uvPart[PaVe[0,0,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/2),
uvPart[PaVe[1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,


(* C001, C002, C111, C112, C122, C222 *)
uvPart[PaVe[0,0,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/6),
uvPart[PaVe[0,0,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/6),

uvPart[PaVe[1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,

(* C0000, C0011, C0012, C0022, C1111, C1112,
C1122, C1222, C2222 *)

uvPart[PaVe[0,0,0,0,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/48)(-4m0^2-4m1^2-4m2^2+SPD[p1,p1]+p12+SPD[p2,p2]),

uvPart[PaVe[0,0,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/12),

uvPart[PaVe[0,0,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/24),
uvPart[PaVe[0,0,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/12),

uvPart[PaVe[1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,


(* C00001, C00002, C00111, C00112, C00122,
C00222, C11111, C11112, C11122, C11222, C12222,
C22222*)

uvPart[PaVe[0,0,0,0,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/240)(5m0^2+10m1^2+5m2^2-2SPD[p1,p1]-2p12-SPD[p2,p2]),

uvPart[PaVe[0,0,0,0,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/240)(5m0^2+5m1^2+10m2^2-SPD[p1,p1]-2p12-2SPD[p2,p2]),

uvPart[PaVe[0,0,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/20),
uvPart[PaVe[0,0,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/60),
uvPart[PaVe[0,0,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/60),
uvPart[PaVe[0,0,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/20),

uvPart[PaVe[1,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,


(* C000000, C000011, C000012, C000022, C001111, C001112,
C001122, C001222, C002222, C111111, C111112, C111122,
C111222, C112222, C122222, C222222 *)

uvPart[PaVe[0,0,0,0,0,0,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/1440)(-15m0^4-15m1^4-15m2^4+3m2^2 SPD[p1,p1]-SPD[p1,p1]^2+6 m2^2 p12 - SPD[p1,p1]p12-p12^2)
+(1/1440)(6m2^2 SPD[p2,p2]-SPD[p1,p1]SPD[p2,p2]-p12 SPD[p2,p2]-SPD[p2,p2]^2+3m1^2(-5m2^2+2SPD[p1,p1]+2p12+SPD[p2,p2]))+
(1/1440)(3m0^2(-5m1^2-5m2^2+2SPD[p1,p1]+p12+2SPD[p2,p2]))
),

uvPart[PaVe[0,0,0,0,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/720)(-6m0^2-18m1^2-6m2^2+3SPD[p1,p1]+3p12+SPD[p2,p2]),

uvPart[PaVe[0,0,0,0,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/720)(-3m0^2-6m1^2-6m2^2+SPD[p1,p1]+2p12+SPD[p2,p2]),

uvPart[PaVe[0,0,0,0,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/720)(-6m0^2-6m1^2-18m2^2+SPD[p1,p1]+3p12+3SPD[p2,p2]),

uvPart[PaVe[0,0,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/30),
uvPart[PaVe[0,0,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/120),
uvPart[PaVe[0,0,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/180),
uvPart[PaVe[0,0,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/120),
uvPart[PaVe[0,0,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(-1/30),

uvPart[PaVe[1,1,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,

(* C0000001, C0000002, C0000111, C0000112, C0000122, C0000222,
C0011111, C0011112, C0011122, C0011222, C0012222, C0022222,
C1111111, C1111112, C1111122, C1111222, C1112222, C1122222, C1222222, C2222222*)


uvPart[PaVe[0,0,0,0,0,0,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/10080)(21m0^4+63m1^4+21m2^4-7m2^2SPD[p1,p1]+3SPD[p1,p1]^2-14m2^2 p12 +3 SPD[p1,p1]p12)
+(1/10080)(3 p12^2-7m2^2 SPD[p2,p2]+2SPD[p1,p1]SPD[p2,p2]+2p12 SPD[p2,p2]+SPD[p2,p2]^2)
+(1/10080)(7m1^2(6m2^2-3SPD[p1,p1]-3p12-SPD[p2,p2]))
+(1/10080)(7m0^2(6m1^2+3m2^2-2SPD[p1,p1]-p12-SPD[p2,p2]))
),

uvPart[PaVe[0,0,0,0,0,0,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/10080)(21m0^4+63m2^4+21m1^4-7m2^2SPD[p1,p1]+SPD[p1,p1]^2-21m2^2 p12 +2 SPD[p1,p1]p12)
+(1/10080)(3 p12^2-21m2^2 SPD[p2,p2]+2SPD[p1,p1]SPD[p2,p2]+3p12 SPD[p2,p2]+3SPD[p2,p2]^2)
+(1/10080)(7m1^2(6m2^2-SPD[p1,p1]-2p12-SPD[p2,p2]))
+(1/10080)(7m0^2(3m1^2+6m2^2-SPD[p1,p1]-p12-2SPD[p2,p2]))
),


uvPart[PaVe[0,0,0,0,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/1680)(
7m0^2+28m1^2+7m2^2-4SPD[p1,p1]-4p12-SPD[p2,p2]
),

uvPart[PaVe[0,0,0,0,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]-> 1/(D-4)(1/5040)(
7m0^2+21m1^2+14m2^2-3SPD[p1,p1]-6p12-2SPD[p2,p2]
),

uvPart[PaVe[0,0,0,0,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]-> 1/(D-4)(1/5040)(
7m0^2+14m1^2+21m2^2-2SPD[p1,p1]-6p12-3SPD[p2,p2]
),

uvPart[PaVe[0,0,0,0,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/1680)(
7m0^2+7m1^2+28m2^2-SPD[p1,p1]-4p12-4SPD[p2,p2]
),

uvPart[PaVe[0,0,1,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/42),
uvPart[PaVe[0,0,1,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/210),
uvPart[PaVe[0,0,1,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/420),
uvPart[PaVe[0,0,1,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/420),
uvPart[PaVe[0,0,1,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/210),
uvPart[PaVe[0,0,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(1/42),

uvPart[PaVe[1,1,1,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,


(* C00000000, C00000011, C00000012, C00000022,
C00001111, C00001112, C00001122, C00001222, C00002222,

C00111111, C00111112, C00111122, C00111222, C00112222, C00122222,
C00222222,

C11111111, C11111112,C11111122, C11111222, C11112222, C11122222,
C11222222, C12222222, C22222222 *)

(*Here*)
uvPart[PaVe[0,0,0,0,0,0,0,0,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]-> 1/(D-4)(

(1/161280)(-168m0^6-168m1^6-168m2^6+28m2^4 SPD[p1,p1]-8m2^2 SPD[p1,p1]^2+3SPD[p1,p1]^3)
+(1/161280)(84m2^4 p12-16m2^2 SPD[p1,p1] p12+3SPD[p1,p1]^2 p12-24m2^2 p12^2+3SPD[p1,p1] p12^2)
+(1/161280)(3 p12^3+84m2^4 SPD[p2,p2]-16m2^2 SPD[p1,p1] SPD[p2,p2]+3SPD[p1,p1]^2SPD[p2,p2]-24m2^2p12 SPD[p2,p2])
+(1/161280)(4 SPD[p1,p1] p12 SPD[p2,p2]+3 p12^2 SPD[p2,p2]-24m2^2SPD[p2,p2]^2+3SPD[p1,p1]SPD[p2,p2]^2+3p12 SPD[p2,p2]^2+3SPD[p2,p2]^3)

+(1/161280)(-28m0^4(6m1^2+6m2^2-3SPD[p1,p1]-p12-3 SPD[p2,p2]))
+(1/161280)(-28m1^4(6m2^2-3SPD[p1,p1]-3p12- SPD[p2,p2]))
+(1/161280)(-8m0^2(21m1^4+21m2^4+3SPD[p1,p1]^2+2SPD[p1,p1]p12+p12^2+3SPD[p1,p1]SPD[p2,p2]+2p12 SPD[p2,p2]
+ 3 SPD[p2,p2]^2-(-1) 7m1^2(3m2^2-2 SPD[p1,p1]-p12-SPD[p2,p2])-7m2^2(SPD[p1,p1]+p12+2SPD[p2,p2])
))
+(1/161280)(-8m1^2(21m2^4+3SPD[p1,p1]^2+3p12^2+2p12 SPD[p2,p2]    +
SPD[p2,p2]^2-7m2^2(SPD[p1,p1]+2p12+SPD[p2,p2])+SPD[p1,p1](3p12+2SPD[p2,p2])
	)  )
),


uvPart[PaVe[0,0,0,0,0,0,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/40320)(-28m0^4-168m1^4-28m2^4+12m2^2SPD[p1,p1]-6SPD[p1,p1]^2+24m2^2 p12)
+(1/40320)(-6 SPD[p1,p1] p12-6p12^2+8 m2^2SPD[p2,p2]-3SPD[p1,p1]SPD[p2,p2]-3p12 SPD[p2,p2]-SPD[p2,p2]^2)
+(1/40320)(-4m0^2(21m1^2+7m2^2-6 SPD[p1,p1]-3p12-2SPD[p2,p2]))
+(1/40320)(12m1^2(-7m2^2+4SPD[p1,p1]+4p12+SPD[p2,p2]))
),

uvPart[PaVe[0,0,0,0,0,0,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/80640)(-28m0^4-84m1^4-84m2^4+16m2^2SPD[p1,p1]-3SPD[p1,p1]^2+48m2^2 p12)
+(1/80640)(-6 SPD[p1,p1] p12-9p12^2+24 m2^2SPD[p2,p2]-4SPD[p1,p1]SPD[p2,p2]-6p12 SPD[p2,p2]-3SPD[p2,p2]^2)
+(1/80640)(-8m0^2(7m1^2+7m2^2- 2( SPD[p1,p1]+p12+SPD[p2,p2])))
+(1/80640)(-8m1^2(14m2^2-3SPD[p1,p1]-2(3p12+SPD[p2,p2])))
),

uvPart[PaVe[0,0,0,0,0,0,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/40320)(-28m0^4-28m1^4-168m2^4+12m2^2SPD[p1,p1]-SPD[p1,p1]^2+48m2^2 p12)
+(1/40320)(-3 SPD[p1,p1] p12-6p12^2+48 m2^2SPD[p2,p2]-3SPD[p1,p1]SPD[p2,p2]-6p12 SPD[p2,p2]-6SPD[p2,p2]^2)
+(1/40320)(-4m0^2(7m1^2+21m2^2-2 SPD[p1,p1]-3p12-6SPD[p2,p2]))
+(1/40320)(m1^2(-84m2^2+8SPD[p1,p1]+24p12+12SPD[p2,p2]))
),

uvPart[PaVe[0,0,0,0,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/3360)(-8m0^2-40m1^2-8m2^2+5SPD[p1,p1]+5p12 +SPD[p2,p2])
),

uvPart[PaVe[0,0,0,0,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)(
(1/6720)(-4m0^2-16m1^2-8m2^2+2SPD[p1,p1]+4p12 +SPD[p2,p2])
),


uvPart[PaVe[0,0,0,0,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(1/20160)(-8m0^2+3(-8m1^2-8m2^2+SPD[p1,p1]+3p12+SPD[p2,p2])),


uvPart[PaVe[0,0,0,0,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(1/6720)(-4m0^2-8m1^2-16m2^2+SPD[p1,p1]+4p12+2SPD[p2,p2]),

uvPart[PaVe[0,0,0,0,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(1/3360)(-8m0^2-8m1^2-40m2^2+SPD[p1,p1]+5p12+5SPD[p2,p2]),

uvPart[PaVe[0,0,1,1,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/56),


uvPart[PaVe[0,0,1,1,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/336),


uvPart[PaVe[0,0,1,1,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/840),


uvPart[PaVe[0,0,1,1,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/1120),


uvPart[PaVe[0,0,1,1,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/840),

uvPart[PaVe[0,0,1,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/336),

uvPart[PaVe[0,0,2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->1/(D-4)*
(-1/56),
uvPart[PaVe[1,1,1,1,1,1,1,1,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,1,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,1,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[1,2,2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0,
uvPart[PaVe[2,2,2,2,2,2,2,2,{SPD[p1,p1],p12,SPD[p2,p2]},{m0^2,m1^2,m2^2}]]->0
};


(* ::Section::Closed:: *)
(*UV parts of D-functions up to rank 8*)


resultsSulyokD={

(*D1, D2, D3*)
uvPart[PaVe[1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

(*D00, D11, D12, D22, D23, D33 *)
uvPart[PaVe[0,0,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

(*D001, D002, D003, D111, D112, D113, D122, D123, D133, D222, D223, D233, D333*)
uvPart[PaVe[0,0,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

(*D0000,

D0011, D0012, D0013, D0022, D0023, D0033,
D1111, D1112, D1113, D1122, D1123, D1133, D1222, D1223, D1233, D1333,
D2222, D2223, D2233, D2333, D3333

*)
uvPart[PaVe[0,0,0,0,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/12),

uvPart[PaVe[0,0,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


uvPart[PaVe[1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


(*D00001, D00002, D00003,

D00111, D00112, D00113, D00122, D00123, D00133, D00222, D00223, D00233, D00333,

D11111, D11112, D11113, D11122, D11123, D11133, D11222, D11223, D11233, D11333,

D12222, D12223, D12233, D12333, D13333,
D22222, D22223, D22233, D22333, D23333, D33333
*)
uvPart[PaVe[0,0,0,0,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/48),
uvPart[PaVe[0,0,0,0,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/48),
uvPart[PaVe[0,0,0,0,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/48),


uvPart[PaVe[0,0,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


uvPart[PaVe[1,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,



(*D000000
D000011, D000012, D000013, D000023, D000033,

D001111, D001112, D001113, D001122, D001123, D001133, D001222, D001223, D001233, D001333,
D002222, D002223, D002233, D002333, D003333,

D111111, D111112, D111113, D111122, D111123, D111133, D111222, D111223, D111233, D111333,
D112222, D112223, D112233, D112333, D113333,

D122222, D122223, D122233, D122333, D123333, D133333,

D222222, D222223, D222233, D222333, D223333, D233333, D333333,

*)
uvPart[PaVe[0,0,0,0,0,0,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/480)(
-5m0^2-5m1^2-5m2^2-5m3^2+SPD[p1,p1]+p12+p13+SPD[p2,p2]+p23+SPD[p3,p3]
),

uvPart[PaVe[0,0,0,0,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/120),
uvPart[PaVe[0,0,0,0,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/240),
uvPart[PaVe[0,0,0,0,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/240),
uvPart[PaVe[0,0,0,0,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/120),
uvPart[PaVe[0,0,0,0,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/240),
uvPart[PaVe[0,0,0,0,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(-1/120),

uvPart[PaVe[0,0,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[0,0,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


uvPart[PaVe[1,1,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,1,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,



uvPart[PaVe[2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

(*

D0000001, D0000002, D0000003,

D0000111, D0000112, D0000113, D0000122, D0000123, D0000133, D0000222, D0000223, D0000233, D0000333,


D0011111, D0011112, D0011113, D0011122, D0011123, D0011133, D0011222, D0011223, D0011233, D0011333,
D0012222, D0012223, D0012233, D0012333, D0013333,
D0022222, D0022223, D0022233, D0022333, D0023333, D0033333,


D1111111, D1111112, D1111113, D1111122, D1111123, D1111133, D1111222, D1111223, D1111233, D1111333,
D1112222, D1112223, D1112233, D1112333, D1113333,
D1122222, D1122223, D1122233, D1122333, D1123333, D1133333


D1222222, D1222223, D1222233, D1222333, D1223333, D1233333, D1333333

D2222222, D2222223, D2222233, D2222333, D2223333, D2233333, D2333333 , D3333333,

*)
uvPart[PaVe[0,0,0,0,0,0,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/2880)(
6m0^2+12m1^2+6m2^2+6m3^2-2SPD[p1,p1]-2p12-2p13-SPD[p2,p2]-p23-SPD[p3,p3]
),
uvPart[PaVe[0,0,0,0,0,0,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/2880)(
6m0^2+6m1^2+12m2^2+6m3^2-SPD[p1,p1]-2p12-p13-2SPD[p2,p2]-2p23-SPD[p3,p3]
),
uvPart[PaVe[0,0,0,0,0,0,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/2880)(
6m0^2+6m1^2+6m2^2+12m3^2-SPD[p1,p1]-p12-2p13-SPD[p2,p2]-2p23-2SPD[p3,p3]
),

uvPart[PaVe[0,0,0,0,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/240),
uvPart[PaVe[0,0,0,0,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/720),
uvPart[PaVe[0,0,0,0,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/720),
uvPart[PaVe[0,0,0,0,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/720),
uvPart[PaVe[0,0,0,0,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/1440),
uvPart[PaVe[0,0,0,0,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/720),
uvPart[PaVe[0,0,0,0,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/240),
uvPart[PaVe[0,0,0,0,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/720),
uvPart[PaVe[0,0,0,0,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/720),
uvPart[PaVe[0,0,0,0,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(1/240),


uvPart[PaVe[0,0,1,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[0,0,1,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,



uvPart[PaVe[1,1,1,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,1,1,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,



uvPart[PaVe[1,2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


uvPart[PaVe[2,2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


(*D00000000,

D00000011, D00000012, D00000022,   D00000023,  D00000033,
D00001111, D00001112, D00001113, D00001122, D00001123, D00001133, D00001222, D00001223, D00001233, D00001333,
D00002222, D00002223, D00002233, D00002333, D00003333,

D00111111, D00111112, D00111113, D00111122, D00111123, D00111133, D00111222, D00111223, D00111233, D00111333,
D00112222, D00112223, D00112233, D00112333, D00113333,
D00122222, D00122223, D00122233, D00122333, D00123333, D00133333,
D00222222, D00222223, D00222233, D00222333, D00223333, D00233333, D00333333,



D11111111, D11111112, D11111113, D11111122, D11111123, D11111133, D11111222, D11111223, D11111233, D11111333,
D11112222, D11112223, D11112233, D11112333, D11113333,
D11122222, D11122223, D11122233, D11122333, D11123333, D11133333,
D11222222, D11222223, D11222233, D11222333, D11223333, D11233333, D11333333,
D12222222, D12222223, D12222233, D12222333, D12223333, D12233333, D12333333,
D22222222, D22222223, D22222233, D22222333, D22223333, D22233333, D22333333,
D23333333, D33333333
*)



uvPart[PaVe[0,0,0,0,0,0,0,0,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->1/(D-4)(
(1/40320)(-42m0^4-42m1^4-42m2^4-42m2^2 m3^2-42 m3^4+7m2^2 SPD[p1,p1])
+(1/40320)(7 m3^2 SPD[p1,p1]-2SPD[p1,p1]^2+14m2^2 p12+7m3^2 p12-2SPD[p1,p1]p12-2p12^2)
+(1/40320)(7 m2^2 p13+14 m3^2 p13-2SPD[p1,p1] p13-2p12 p13-2p13^2+14m2^2SPD[p2,p2])
+(1/40320)(7 m3^2 SPD[p2,p2]-2SPD[p1,p1]SPD[p2,p2]-2p12 SPD[p2,p2]-p13 SPD[p2,p2]-2 SPD[p2,p2]^2+14 m2^2 p23)
+(1/40320)(14 m3^2 p23-SPD[p1,p1]p23-2p12 p23-2p13 p23-2SPD[p2,p2]p23-2p23^2)
+(1/40320)(7m2^2 SPD[p3,p3]+14 m3^2 SPD[p3,p3]-2SPD[p1,p1]SPD[p3,p3]-p12 SPD[p3,p3]-2p13 SPD[p3,p3]-2SPD[p2,p2]SPD[p3,p3])

+(1/40320)(-2p23 SPD[p3,p3]-2SPD[p3,p3]^2-7m0^2(6m1^2+6m2^2+6m3^2-2SPD[p1,p1]-p12-p13-2SPD[p2,p2]-p23-2SPD[p3,p3]))

+(1/40320)(7m1^2(-6m2^2-6m3^2+2SPD[p1,p1]+2p12+2p13+SPD[p2,p2]+p23+SPD[p3,p3]))
),


uvPart[PaVe[0,0,0,0,0,0,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)((1/10080)(-7m0^2-21m1^2-7m2^2-7m3^2)+(1/10080)(3SPD[p1,p1]+3p12+3p13+SPD[p2,p2]+p23+SPD[p3,p3])),

uvPart[PaVe[0,0,0,0,0,0,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)((1/20160)(-7m0^2-14m1^2-14m2^2-7m3^2)+(1/20160)(2SPD[p1,p1]+4p12+2p13+2SPD[p2,p2]+2p23+SPD[p3,p3])),

uvPart[PaVe[0,0,0,0,0,0,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)((1/20160)(-7m0^2-14m1^2-7m2^2-14m3^2)+(1/20160)(2SPD[p1,p1]+2p12+4p13+SPD[p2,p2]+2p23+2SPD[p3,p3])),


uvPart[PaVe[0,0,0,0,0,0,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)((1/10080)(-7m0^2-7m1^2-21m2^2-7m3^2)+(1/10080)(SPD[p1,p1]+3p12+p13+3SPD[p2,p2]+3p23+SPD[p3,p3])),


uvPart[PaVe[0,0,0,0,0,0,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)((1/20160)(-7m0^2-7m1^2-14m2^2-14m3^2)+(1/20160)(SPD[p1,p1]+2p12+2p13+2SPD[p2,p2]+4p23+2SPD[p3,p3])),

uvPart[PaVe[0,0,0,0,0,0,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)((1/10080)(-7m0^2-7m1^2-7m2^2-21m3^2)+(1/10080)(SPD[p1,p1]+p12+3p13+SPD[p2,p2]+3p23+3SPD[p3,p3])),



uvPart[PaVe[0,0,0,0,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/420),

uvPart[PaVe[0,0,0,0,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/1680),


uvPart[PaVe[0,0,0,0,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/1680),

uvPart[PaVe[0,0,0,0,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/2520),

uvPart[PaVe[0,0,0,0,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/5040),

uvPart[PaVe[0,0,0,0,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/2520),


uvPart[PaVe[0,0,0,0,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/1680),

uvPart[PaVe[0,0,0,0,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/5040),


uvPart[PaVe[0,0,0,0,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/5040),

uvPart[PaVe[0,0,0,0,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/1680),


uvPart[PaVe[0,0,0,0,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/420),


uvPart[PaVe[0,0,0,0,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/1680),


uvPart[PaVe[0,0,0,0,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/2520),

uvPart[PaVe[0,0,0,0,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/1680),

uvPart[PaVe[0,0,0,0,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->
1/(D-4)(-1/420),



uvPart[PaVe[0,0,1,1,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[0,0,1,1,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,1,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[0,0,1,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,1,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,



uvPart[PaVe[0,0,2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[0,0,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,





uvPart[PaVe[1,1,1,1,1,1,1,1,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,1,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,1,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,1,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,1,1,1,1,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,1,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,1,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,1,1,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,1,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,



uvPart[PaVe[1,1,2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,1,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,

uvPart[PaVe[1,2,2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[1,2,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,


uvPart[PaVe[2,2,2,2,2,2,2,2,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,2,2,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,2,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,2,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,2,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,2,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,2,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[2,3,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0,
uvPart[PaVe[3,3,3,3,3,3,3,3,{SPD[p1,p1],p12,p23,SPD[p3,p3],SPD[p2,p2],p13},{m0^2,m1^2,m2^2,m3^2}]]->0
};


(* ::Section:: *)
(*Checking the results with Package-X*)


(* ::Text:: *)
(*Now we create a list of Passarino-Veltman functions for which we know the UV-parts*)


paveListB=(FCReplaceD[#,D->4-2Epsilon]&/@resultsSulyokB)/.Rule[a_,b_]:>a/.uvPart->Identity;
paveListC=(FCReplaceD[#,D->4-2Epsilon]&/@resultsSulyokC)/.Rule[a_,b_]:>a/.uvPart->Identity;
paveListD=(FCReplaceD[#,D->4-2Epsilon]&/@resultsSulyokD)/.Rule[a_,b_]:>a/.uvPart->Identity;


(* ::Text:: *)
(*and compute the UV-parts using Package-X*)


paxResultB=Factor2/@(PaXEvaluateUV/@paveListB);
paxResultC=Factor2/@(PaXEvaluateUV/@paveListC);
paxResultD=Factor2/@(PaXEvaluateUV/@paveListD);


(* ::Text:: *)
(*Then we put all the Package-X results into one list*)


paxResult=Join[paxResultB,paxResultC,paxResultD];


(* ::Text:: *)
(*and compare that to the literature (G. Sulyok,  hep-ph/0609282)*)


resultSulyok=Factor2/@(FCReplaceD[#,D->4-2EpsilonUV]&/@(Join[resultsSulyokB,resultsSulyokC,resultsSulyokD]/.Rule[_,a_]:>a));


Print["Check with Sulyok, hep-ph/0609282: ",
			If[paxResult===resultSulyok, "CORRECT.", "!!! WRONG !!!"]];
