
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            sum <= 8'b0;
            cout <= 1'b0;
        end else begin
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                reg [1:0] sum_i = {a[i], b[i]};
                reg [1:0] cin_i = {cin, i == 0};
                reg [1:0] cout_i = sum_i[0] ^ cin_i[0] ^ cout_i[0];
                sum[i] <= sum_i[1];
                cout <= cout_i[1];
            end
        end
    end

endmodule
