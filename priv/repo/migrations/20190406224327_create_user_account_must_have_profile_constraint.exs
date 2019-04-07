defmodule PostgrexBug.Repo.Migrations.CreateAccountMustHaveProfileConstraint do
  use Ecto.Migration

  def up do
    confirm_account_has_profile = """
        CREATE OR REPLACE FUNCTION confirm_account_has_profile() RETURNS TRIGGER AS
        $$
        DECLARE
        BEGIN
          IF NOT EXISTS(SELECT * FROM profiles WHERE profiles.account_id = NEW.id) THEN
            RAISE EXCEPTION 'Account for % must have a Profile!', NEW.email_address;
          END IF;

          RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;
    """

    execute(confirm_account_has_profile)

    trigger_account_has_profile = """
        CREATE CONSTRAINT TRIGGER trigger_account_has_profile AFTER INSERT OR UPDATE ON accounts
        DEFERRABLE INITIALLY DEFERRED
        FOR EACH ROW EXECUTE PROCEDURE confirm_account_has_profile();
    """

    execute(trigger_account_has_profile)
  end

  def down do
    execute("DROP TRIGGER trigger_account_has_profile ON accounts;")
    execute("DROP FUNCTION confirm_account_has_profile();")
  end
end
