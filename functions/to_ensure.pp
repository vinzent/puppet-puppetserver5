function puppetserver5::to_ensure($value) >> Enum['present','absent'] {
  case $value {
    'ABSENT': { 'absent' }
    default: { 'present' }
  }
}
