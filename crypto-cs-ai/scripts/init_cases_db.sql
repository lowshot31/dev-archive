CREATE TABLE IF NOT EXISTS cases (
  id BIGSERIAL PRIMARY KEY,
  case_id TEXT UNIQUE,
  status TEXT NOT NULL DEFAULT 'OPEN',
  assignee_slack_user_id TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  slack_channel_id TEXT,
  slack_message_ts TEXT,
  intent TEXT,
  coin TEXT,
  network TEXT,
  txid TEXT,
  onchain_status TEXT,
  action TEXT
);

CREATE OR REPLACE FUNCTION generate_case_id()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.case_id IS NULL THEN
    NEW.case_id := 'CS-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(NEW.id::TEXT, 4, '0');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_set_case_id ON cases;
CREATE TRIGGER trg_set_case_id
BEFORE INSERT ON cases
FOR EACH ROW
EXECUTE FUNCTION generate_case_id();

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_set_updated_at ON cases;
CREATE TRIGGER trg_set_updated_at
BEFORE UPDATE ON cases
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
