`timescale 1ns / 1ps

module array_mult_generate(
    input [3:0] m,
    input [3:0] q,
    output [7:0] p
    );

    // Partial products
    wire pp_0_0, pp_0_1, pp_0_2, pp_0_3;
    wire pp_1_0, pp_1_1, pp_1_2, pp_1_3;
    wire pp_2_0, pp_2_1, pp_2_2, pp_2_3;
    wire pp_3_0, pp_3_1, pp_3_2, pp_3_3;

    // Sum and carry wires
    wire sum_0_0, sum_0_1, sum_0_2;
    wire sum_1_0, sum_1_1, sum_1_2;

    wire carry_0_0, carry_0_1, carry_0_2, carry_0_3;
    wire carry_1_0, carry_1_1, carry_1_2, carry_1_3;
    wire carry_2_0, carry_2_1, carry_2_2, carry_2_3;

    // Generate partial products
    assign pp_0_0 = m[0] & q[0];
    assign pp_0_1 = m[0] & q[1];
    assign pp_0_2 = m[0] & q[2];
    assign pp_0_3 = m[0] & q[3];

    assign pp_1_0 = m[1] & q[0];
    assign pp_1_1 = m[1] & q[1];
    assign pp_1_2 = m[1] & q[2];
    assign pp_1_3 = m[1] & q[3];

    assign pp_2_0 = m[2] & q[0];
    assign pp_2_1 = m[2] & q[1];
    assign pp_2_2 = m[2] & q[2];
    assign pp_2_3 = m[2] & q[3];

    assign pp_3_0 = m[3] & q[0];
    assign pp_3_1 = m[3] & q[1];
    assign pp_3_2 = m[3] & q[2];
    assign pp_3_3 = m[3] & q[3];

    // Assign p[0]
    assign p[0] = pp_0_0;

    // First row of full adders
    full_adder fa0_0 (
        .a(pp_0_1),
        .b(pp_1_0),
        .cin(1'b0),
        .sum(p[1]),
        .cout(carry_0_0)
    );

    full_adder fa0_1 (
        .a(pp_0_2),
        .b(pp_1_1),
        .cin(carry_0_0),
        .sum(sum_0_0),
        .cout(carry_0_1)
    );

    full_adder fa0_2 (
        .a(pp_0_3),
        .b(pp_1_2),
        .cin(carry_0_1),
        .sum(sum_0_1),
        .cout(carry_0_2)
    );

    full_adder fa0_3 (
        .a(1'b0), // pp_0_4 doesn't exist
        .b(pp_1_3),
        .cin(carry_0_2),
        .sum(sum_0_2),
        .cout(carry_0_3)
    );

    // Second row of full adders
    full_adder fa1_0 (
        .a(sum_0_0),
        .b(pp_2_0),
        .cin(1'b0),
        .sum(p[2]),
        .cout(carry_1_0)
    );

    full_adder fa1_1 (
        .a(sum_0_1),
        .b(pp_2_1),
        .cin(carry_1_0),
        .sum(sum_1_0),
        .cout(carry_1_1)
    );

    full_adder fa1_2 (
        .a(sum_0_2),
        .b(pp_2_2),
        .cin(carry_1_1),
        .sum(sum_1_1),
        .cout(carry_1_2)
    );

    full_adder fa1_3 (
        .a(carry_0_3),
        .b(pp_2_3),
        .cin(carry_1_2),
        .sum(sum_1_2),
        .cout(carry_1_3)
    );

    // Third row of full adders
    full_adder fa2_0 (
        .a(sum_1_0),
        .b(pp_3_0),
        .cin(1'b0),
        .sum(p[3]),
        .cout(carry_2_0)
    );

    full_adder fa2_1 (
        .a(sum_1_1),
        .b(pp_3_1),
        .cin(carry_2_0),
        .sum(p[4]),
        .cout(carry_2_1)
    );

    full_adder fa2_2 (
        .a(sum_1_2),
        .b(pp_3_2),
        .cin(carry_2_1),
        .sum(p[5]),
        .cout(carry_2_2)
    );

    full_adder fa2_3 (
        .a(carry_1_3),
        .b(pp_3_3),
        .cin(carry_2_2),
        .sum(p[6]),
        .cout(carry_2_3)
    );

    // Assign p[7]
    assign p[7] = carry_2_3;

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
