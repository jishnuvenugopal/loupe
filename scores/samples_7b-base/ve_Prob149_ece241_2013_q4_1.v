
module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] current_state;
    reg [2:0] previous_state;
    reg [2:0] flow_rate;

    
    parameter STATE_0 = 3'b000;
 
    parameter STATE_1 = 3'b001;
 
    parameter STATE_2 = 3'b010;
 
    parameter STATE_3 = 3'b011;
 

    
    parameter FLOW_0 = 3'b000;
 
    parameter FLOW_1 = 3'b001;
 
    parameter FLOW_2 = 3'b010;
 
    parameter FLOW_3 = 3'b011;
 

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_0;
            previous_state <= STATE_0;
            flow_rate <= FLOW_0;
            dfr <= 1'b0;
        end else begin
            previous_state <= current_state;
            current_state <= s;
            if (s == STATE_0) begin
                flow_rate <= FLOW_0;
                dfr <= 1'b0;
            end else if (s == STATE_1) begin
                if (previous_state == STATE_0) begin
                    flow_rate <= FLOW_1;
                    dfr <= 1'b1;
                end else begin
                    flow_rate <= FLOW_1;
                    dfr <= 1'b0;
                end
            end else if (s == STATE_2) begin
                if (previous_state == STATE_1) begin
                    flow_rate <= FLOW_2;
                    dfr <= 1'b1;
                end else begin
                    flow_rate <= FLOW_2;
                    dfr <= 1'b0;
                end
            end else if (s == STATE_3) begin
                flow_rate <= FLOW_3;
                dfr <= 1'b0;
            end
        end
    end

    
    assign fr2 = (flow_rate == FLOW_0) || (flow_rate == FLOW_3);
    assign fr1 = (flow_rate == FLOW_1) || (flow_rate == FLOW_2);
    assign fr0 = (flow_rate == FLOW_1) || (flow_rate == FLOW_2) || (flow_rate == FLOW_3);

endmodule
