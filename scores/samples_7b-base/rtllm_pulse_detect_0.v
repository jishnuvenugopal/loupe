
module pulse_detect (
    input wire clk,       
    input wire rst_n,     
    input wire data_in,   
    output reg data_out   
);


localparam IDLE = 2'b00;
localparam DETECTING = 2'b01;
localparam PULSE_ENDED = 2'b10;


reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= DETECTING;
                end
                data_out <= 0;
            end
            DETECTING: begin
                if (!data_in) begin
                    state <= PULSE_ENDED;
                end
                data_out <= 0;
            end
            PULSE_ENDED: begin
                state <= IDLE;
                data_out <= 1;
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule
