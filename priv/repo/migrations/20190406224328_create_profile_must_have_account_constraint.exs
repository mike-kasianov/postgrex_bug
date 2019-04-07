defmodule PostgrexBug.Repo.Migrations.CreateProfileMustHaveAccountConstraint do
  use Ecto.Migration

  def up do
    confirm_profile_has_account = """
        CREATE OR REPLACE FUNCTION confirm_profile_has_account() RETURNS TRIGGER AS
        $$
        DECLARE
        BEGIN
          IF EXISTS(SELECT * FROM accounts WHERE accounts.id = OLD.account_id) THEN
            RAISE EXCEPTION 'Profile id: % must not be deleted separately from it''s Account!', OLD.id;
          END IF;

          RETURN OLD;
        END;
        $$ LANGUAGE plpgsql;
    """

    execute(confirm_profile_has_account)

    trigger_account_has_profile = """
        CREATE CONSTRAINT TRIGGER trigger_account_has_profile AFTER UPDATE OR DELETE ON profiles
        DEFERRABLE INITIALLY DEFERRED
        FOR EACH ROW EXECUTE PROCEDURE confirm_profile_has_account();
    """

    execute(trigger_account_has_profile)
  end

  def down do
    execute("DROP TRIGGER trigger_account_has_profile ON profiles;")
    execute("DROP FUNCTION confirm_profile_has_account();")
  end
end
