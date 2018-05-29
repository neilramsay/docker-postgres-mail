-- Create test user for usage with Dovecot
-- Password is 'test123' run through doveadm pw -s SHA512-CRYPT

INSERT INTO users VALUES ('test', 'example.com', '{SHA512-CRYPT}$6$.WMmvo2Ld1KQTDjP$ZCjG/j2f/6VzNgW4L4XOu0OMCpvh40vILFF4cvE4vK1G5K4YA72WAff3oI1CPKsp1wJqG1Dt9VGsAA.B0aqTh0', '/tmp', NULL, 1000, 1000);
