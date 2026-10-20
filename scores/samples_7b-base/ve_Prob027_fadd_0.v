
module TopModule(a, b, cin, sum, cout);
    input a, b, cin;
    output cout, sum;

    wire intermediate_sum;
    wire intermediate_cout;

    FullAdder fa (.a(a), .b(b), .cin(cin), .sum(intermediate_sum), .cout(intermediate_cout));

    assign sum = intermediate_sum;
    assign cout = intermediate_cout;
endmodule
