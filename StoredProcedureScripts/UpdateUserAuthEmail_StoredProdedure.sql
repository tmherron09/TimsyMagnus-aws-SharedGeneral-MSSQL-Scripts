CREATE PROCEDURE UpdateUserAuthEmail @Username NVARCHAR(50),
                                     @UpdateEmail NVARCHAR(255)
AS

DECLARE
    @Username    nvarchar(50)  = 'notinhere',
    @UpdateEmail nvarchar(255) = 'notAnEmail@eskdfs.com';
BEGIN
    DECLARE @UpdatedUserAuth TABLE
                             (
                                 UserAuthId INT,
                                 Email      NVARCHAR(255),
                                 Username   NVARCHAR(50)
                                 -- Add other columns as needed
                             );

    -- Check if the specified username exists
    IF EXISTS (SELECT 1 FROM UserAuth WHERE Username = @Username)
        BEGIN

            -- Update the Email for the specified username
            UPDATE UserAuth
            SET Email = @UpdateEmail
            OUTPUT INSERTED.UserAuthId,
                   INSERTED.Email,
                   INSERTED.Username INTO @UpdatedUserAuth
            WHERE Username = @Username

            -- Select the updated UserAuth item
            SELECT * FROM @UpdatedUserAuth;
        END
    ELSE
        BEGIN
            -- Username not found, throw an error
            DECLARE @ErrorMessage NVARCHAR(255) = 'Username not found.';
            RAISERROR (@ErrorMessage, 16, 1);
        END
END;
