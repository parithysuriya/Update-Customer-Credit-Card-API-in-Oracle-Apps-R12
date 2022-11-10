DECLARE
   x_return_status     VARCHAR2 (1000);
   x_msg_count         NUMBER;
   x_msg_data          VARCHAR2 (4000);
   x_card_id           NUMBER;
   x_msg_data_out      VARCHAR2 (240);
   x_mesg              VARCHAR2 (240);
   x_count             NUMBER;
   x_response          iby_fndcpt_common_pub.result_rec_type;
   l_card_instrument   iby_fndcpt_setup_pub.creditcard_rec_type;
   v_context           VARCHAR2 (10);
   p_init_msg_list     varchar2(50);
   p_commit            varchar2(50);
   l_msg_index_out          NUMBER;
   l_error_message          VARCHAR2 (100);
BEGIN
     l_card_instrument.card_id          :='&card_id';                           
     l_card_instrument.expiration_date :=to_date('12/23/2018','mm/dd/yyyy');   
                   
     
     IBY_FNDCPT_SETUP_PUB.UPDATE_CARD
                       (p_api_version          => 1.0,
                        x_return_status        => x_return_status,
                        x_msg_count            => x_msg_count,
                        x_msg_data             => x_msg_data,
                        p_card_instrument      => l_card_instrument,
                        x_response             => x_response,
                        p_init_msg_list        => fnd_api.g_false,
                        p_commit               => fnd_api.g_true
                        );
        DBMS_OUTPUT.put_line ('output information');
        DBMS_OUTPUT.put_line ('x_msg_count = ' || x_msg_count);
        DBMS_OUTPUT.put_line ('x_return_status = ' || x_return_status);
     IF x_msg_count > 0 THEN
         FOR i IN 1 .. x_msg_count
         LOOP
            apps.fnd_msg_pub.get (p_msg_index          => i,
                                  p_encoded            => fnd_api.g_false,
                                  p_data               => x_msg_data,
                                  p_msg_index_out      => l_msg_index_out
                                 );
         END LOOP;

         IF l_error_message IS NULL
         THEN
            l_error_message := SUBSTR (x_msg_data, 1, 250);
         ELSE
            l_error_message :=
                       l_error_message || ' /' || SUBSTR (x_msg_data, 1, 250);
         END IF;

         DBMS_OUTPUT.put_line ('*****************************************');
         DBMS_OUTPUT.put_line ('API Error : ' || l_error_message);
         DBMS_OUTPUT.put_line ('*****************************************');
      END IF;
END;
