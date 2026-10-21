
module TopModule (
    input clk,
    input rst,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA} state_t;
    state_t state = IDLE;

    
    reg [2:0] byte_count = 0;
    reg [7:0] current_byte = 0;

    
    datapath datapath (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out_bytes(out_bytes),
        .done(done)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            byte_count <= 0;
            current_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        byte_count <= 0;
                        current_byte <= in;
                    end
                end
                MESSAGE_START: begin
                    if (byte_count == 0) begin
                        current_byte <= in;
                    end else if (byte_count == 1) begin
                        current_byte <= in;
                    end else if (byte_count == 2) begin
                        state <= MESSAGE_DATA;
                        byte_count <= 0;
                        current_byte <= in;
                    end
                end
                MESSAGE_DATA: begin
                    if (byte_count == 0) begin
                        current_byte <= in;
                    end else if (byte_count == 1) begin
                        current_byte <= in;
                    end else if (byte_count == 2) begin
                        state <= MESSAGE_DATA;
                        byte_count <= 0;
                        current_byte <= in;
                    end
                end
            endcase
        end
    end

endmodule

module datapath (
    input clk,
    input rst,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    reg [2:0] byte_count = 0;
    reg [7:0] current_byte = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_count <= 0;
            current_byte <= 0;
        end else begin
            case (byte_count)
                0: begin
                    if (in[3] == 1) begin
                        byte_count <= 1;
                        current_byte <= in;
                    end
                end
                1: begin
                    if (in[3] == 1) begin
                        byte_count <= 2;
                        current_byte <= in;
                    end
                end
                2: begin
                    if (in[3] == 1) begin
                        done <= 1;
                        out_bytes <= {current_byte[7:0], current_byte[15:8], current_byte[23:16]};
                        byte_count <= 0;
                        current_byte <= 0;
                    end
                end
            endcase
        end
    end

endmodule
