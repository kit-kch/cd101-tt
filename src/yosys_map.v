// https://github.com/RTimothyEdwards/chaos_automaton/blob/26c763e32bd86d9d870354874988d2bd03bf1009/openlane/user_project_wrapper/yosys_mapping.v#L22
// https://github.com/The-OpenROAD-Project/OpenLane/issues/1070

module \$_ALDFF_PN_ (D, C, L, AD, Q);
input D, C, L, AD;
output reg Q;

wire RN, SN;
wire L_N;

\$_OR_ R_NAND ( .Y(RN), .A(L), .B(AD) );
\$_NOT_ NAND_NOT ( .A(L), .Y(L_N));
\$_NAND_ S_NAND ( .Y(SN), .A(L_N), .B(AD) );

\$_DFFSR_PNN_ SRFF (.C(C), 
    .S(SN), 
    .R(RN), 
    .D(D), 
    .Q(Q)
);

endmodule

module \$_ALDFF_PP_ (D, C, L, AD, Q);
input D, C, L, AD;
output reg Q;

wire RN, SN;
wire L_N;

\$_OR_ R_NAND ( .Y(RN), .A(L_N), .B(AD) );
\$_NOT_ NAND_NOT ( .A(L), .Y(L_N));
\$_NAND_ S_NAND ( .Y(SN), .A(L), .B(AD) );

\$_DFFSR_PNN_ SRFF (.C(C), 
    .S(SN), 
    .R(RN), 
    .D(D), 
    .Q(Q)
);

endmodule