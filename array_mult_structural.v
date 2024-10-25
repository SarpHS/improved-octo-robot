`timescale 1ns / 1ps 

module array_mult_structural(
    input [3:0] m,
    input [3:0] q,
    output [7:0] p
    );

    wire [3:0] pp[3:0]; // Partial products
    wire [7:0] sum[2:0]; // Sum wires
    wire [7:0] carry[2:0]; // Carry wires

    // Generate partial products
    genvar i, j;
    generate
        for (i=0; i<4; i=i+1) begin: loop_i
            for (j=0; j<4; j=j+1) begin: loop_j
                assign pp[i][j] = m[i] & q[j];
            end
        end
    endgenerate

    // First stage
    assign p[0] = pp[0][0];

    // First row
    full_adder fa0_1 (.a(pp[0][1]), .b(pp[1][0]), .cin(1'b0), .sum(p[1]), .cout(carry[0][0]));
    full_adder fa0_2 (.a(pp[0][2]), .b(pp[1][1]), .cin(carry[0][0]), .sum(sum[0][0]), .cout(carry[0][1]));
    full_adder fa0_3 (.a(pp[0][3]), .b(pp[1][2]), .cin(carry[0][1]), .sum(sum[0][1]), .cout(carry[0][2]));
    full_adder fa0_4 (.a(1'b0),      .b(pp[1][3]), .cin(carry[0][2]), .sum(sum[0][2]), .cout(carry[0][3]));

    // Second row
    full_adder fa1_1 (.a(sum[0][0]), .b(pp[2][0]), .cin(1'b0),        .sum(p[2]),      .cout(carry[1][0]));
    full_adder fa1_2 (.a(sum[0][1]), .b(pp[2][1]), .cin(carry[1][0]), .sum(sum[1][0]), .cout(carry[1][1]));
    full_adder fa1_3 (.a(sum[0][2]), .b(pp[2][2]), .cin(carry[1][1]), .sum(sum[1][1]), .cout(carry[1][2]));
    full_adder fa1_4 (.a(carry[0][3]), .b(pp[2][3]), .cin(carry[1][2]), .sum(sum[1][2]), .cout(carry[1][3]));

    // Third row
    full_adder fa2_1 (.a(sum[1][0]), .b(pp[3][0]), .cin(1'b0),        .sum(p[3]),      .cout(carry[2][0]));
    full_adder fa2_2 (.a(sum[1][1]), .b(pp[3][1]), .cin(carry[2][0]), .sum(p[4]),      .cout(carry[2][1]));
    full_adder fa2_3 (.a(sum[1][2]), .b(pp[3][2]), .cin(carry[2][1]), .sum(p[5]),      .cout(carry[2][2]));
    full_adder fa2_4 (.a(carry[1][3]), .b(pp[3][3]), .cin(carry[2][2]), .sum(p[6]),    .cout(p[7]));

endmodule

// Full Adder module definition
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule
