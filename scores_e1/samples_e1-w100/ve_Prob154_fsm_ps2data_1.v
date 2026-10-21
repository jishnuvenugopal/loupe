
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum {IDLE, SEARCHING, RECEIVING} state_t;
    state_t current_state = IDLE;

    
    reg [7:0] current_byte;
    reg [2:0] byte_count;

    
    datapath datapath (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out_bytes(out_bytes),
        .done(done)
    );

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state = IDLE;
            current_byte = 8'b0;
            byte_count = 3'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (in[3] == 1) begin
                        current_state = SEARCHING;
                        current_byte = in;
                        byte_count = 3'b0;
                    end
                end
                SEARCHING: begin
                    if (in[3] == 1) begin
                        current_state = RECEIVING;
                        current_byte = in;
                        byte_count = 3'b0;
                    end
                end
                RECEIVING: begin
                    current_byte = {current_byte[7:0], in};
                    byte_count = byte_count + 1;
                    if (byte_count == 3'b11) begin
                        current_state = IDLE;
                        done = 1'b1;
                    end
                end
                default: begin
                    current_state = IDLE;
                    current_byte = 8'b0;
                    byte_count = 3'b0;
                end
            endcase
        end
    end

endmodule

module datapath (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    reg [7:0] current_byte;
    reg [2:0] byte_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_byte = 8'b0;
            byte_count = 3'b0;
        end else begin
            case (byte_count)
                3'b0: begin
                    out_bytes[23:16] = current_byte[7:0];
                    byte_count = 3'b1;
                end
                3'b1: begin
                    out_bytes[15:8] = current_byte[7:0];
                    byte_count = 3'b2;
                end
                3'b2: begin
                    out_bytes[7:0] = current_byte[7:0];
                    byte_count = 3'b3;
                end
                3'b3: begin
                    out_bytes[23:16] = current_byte[7:0];
                    byte_count = 3'b0;
                    done = 1'b1;
                end
                default: begin
                    out_bytes[23:16] = current_byte[7:0];
                    byte_count = 3'b0;
                end
            endcase
        end
    end

endmodule
