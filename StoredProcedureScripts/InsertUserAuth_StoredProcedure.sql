CREATE PROCEDURE [dbo].[InsertUserAuth]
    @Email NVARCHAR(255),
    @Username NVARCHAR(50),
    @HashedPassword VARBINARY(MAX)
AS
BEGIN
    -- Check if the email and username are unique
    IF NOT EXISTS (SELECT 1 FROM SharedUser.dbo.UserAuth WHERE Email = @Email)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM UserAuth WHERE Username = @Username)
        BEGIN
			DECLARE @startDate		datetime2 = SYSDATETIME();
			DECLARE @endDate		datetime2 = '9999-12-31T23:59:59.9999999';

            -- Insert the new user entry
            INSERT INTO UserAuth (Email, Username, HashedPassword,CreatedDate)
            VALUES (@Email, @Username, @HashedPassword, SYSDATETIME());
            
            SELECT SCOPE_IDENTITY() AS UserAuthId; -- Return the generated UserAuthId
        END
        ELSE
        BEGIN
            -- Username is not unique
            SELECT -1 AS UserAuthId; -- Return -1 to indicate username conflict
        END
    END
    ELSE
    BEGIN
        -- Email is not unique
        SELECT -2 AS UserAuthId; -- Return -2 to indicate email conflict
    END
END;
