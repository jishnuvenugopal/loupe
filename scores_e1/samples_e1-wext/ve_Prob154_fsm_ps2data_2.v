
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    
    datapath datapath (
        .clk(clk),
        .reset(reset),
        .in(in),
        .done(done),
        .out_bytes(out_bytes)
    );

    
    state_machine state_machine (
        .clk(clk),
        .reset(reset),
        .in(in),
        .done(done),
        .out_bytes(out_bytes)
    );

endmodule

module datapath (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    reg [23:0] message;
    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            message <= 0;
            state <= 0;
            done <= 0;
        end else begin
            case (state)
                0: begin
                    if (in[3] == 1) begin
                        state <= 1;
                        message <= in;
                    end
                end
                1: begin
                    if (in[3] == 1) begin
                        state <= 2;
                        message <= message << 8 | in;
                    end
                end
                2: begin
                    if (in[3] == 1) begin
                        state <= 3;
                        message <= message << 8 | in;
                        done <= 1;
                    end
                end
                default: begin
                    state <= 0;
                    message <= 0;
                    done <= 0;
                end
            endcase
        end
    end

endmodule

module state_machine (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (in[3] == 1) begin
                        state <= 1;
                    end
                end
                1: begin
                    if (in[3] == 1) begin
                        state <= 2;
                    end
                end
                2: begin
                    if (in[3] == 1) begin
                        state <= 3;
                    end
                end
                default: begin
                    state <= 0;
                end
            endcase
        end
    end

endmodule
