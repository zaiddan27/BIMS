/**
 * BIMS Database Setup Test Script
 * Run this in browser console after setting up migrations
 */

async function testDatabaseSetup() {
  console.log('🚀 Starting BIMS Database Tests...\n');

  // Test 1: Check if user is authenticated
  console.log('Test 1: Authentication Check');
  const { data: { user }, error: authError } = await supabaseClient.auth.getUser();
  if (authError) {
    console.error('❌ Not authenticated:', authError.message);
    return;
  }
  console.log('✅ Authenticated as:', user.email);
  console.log('   User ID:', user.id);
  console.log('');

  // Test 2: Check if user exists in User_Tbl
  console.log('Test 2: User_Tbl Check');
  const { data: userData, error: userError } = await supabaseClient
    .from('User_Tbl')
    .select('*')
    .eq('userID', user.id)
    .single();

  if (userError) {
    console.error('❌ User not found in User_Tbl:', userError.message);
  } else {
    console.log('✅ User found in User_Tbl');
    console.log('   Name:', userData.firstName, userData.lastName);
    console.log('   Role:', userData.role);
    console.log('   Status:', userData.accountStatus);
  }
  console.log('');

  // Test 3: Check table access permissions
  console.log('Test 3: Table Access Permissions');

  const tables = [
    'User_Tbl',
    'Announcement_Tbl',
    'File_Tbl',
    'Pre_Project_Tbl',
    'Application_Tbl',
    'Inquiry_Tbl',
    'Notification_Tbl'
  ];

  for (const table of tables) {
    const { data, error } = await supabaseClient
      .from(table)
      .select('count')
      .limit(1);

    if (error) {
      console.log(`❌ ${table}: Access denied - ${error.message}`);
    } else {
      console.log(`✅ ${table}: Can read`);
    }
  }
  console.log('');

  // Test 4: Check storage buckets
  console.log('Test 4: Storage Buckets');
  const { data: buckets, error: bucketsError } = await supabaseClient
    .storage
    .listBuckets();

  if (bucketsError) {
    console.error('❌ Cannot list buckets:', bucketsError.message);
  } else {
    console.log('✅ Storage buckets available:');
    buckets.forEach(bucket => {
      console.log(`   - ${bucket.name} (${bucket.public ? 'public' : 'private'})`);
    });
  }
  console.log('');

  // Test 5: Test notification creation
  console.log('Test 5: Notification System');
  const { data: notifData, error: notifError } = await supabaseClient
    .rpc('create_notification', {
      p_user_id: user.id,
      p_notification_type: 'new_announcement',
      p_title: 'Test notification from database setup test'
    });

  if (notifError) {
    console.error('❌ Cannot create notification:', notifError.message);
  } else {
    console.log('✅ Notification created successfully');
    console.log('   Notification ID:', notifData);
  }
  console.log('');

  // Test 6: Check user's notifications
  console.log('Test 6: Read Notifications');
  const { data: notifications, error: notifReadError } = await supabaseClient
    .from('Notification_Tbl')
    .select('*')
    .eq('userID', user.id)
    .order('createdAt', { ascending: false })
    .limit(5);

  if (notifReadError) {
    console.error('❌ Cannot read notifications:', notifReadError.message);
  } else {
    console.log(`✅ Found ${notifications.length} notification(s)`);
    notifications.forEach((notif, index) => {
      console.log(`   ${index + 1}. [${notif.notificationType}] ${notif.title}`);
    });
  }
  console.log('');

  // Test 7: Test profile update function
  console.log('Test 7: Profile Update Function');
  const { data: profileData, error: profileError } = await supabaseClient
    .rpc('update_user_profile', {
      p_first_name: userData.firstName,
      p_last_name: userData.lastName,
      p_middle_name: userData.middleName,
      p_birthday: userData.birthday,
      p_contact_number: userData.contactNumber,
      p_address: userData.address,
      p_image_path_url: userData.imagePathURL
    });

  if (profileError) {
    console.error('❌ Cannot update profile:', profileError.message);
  } else {
    console.log('✅ Profile update function works');
  }
  console.log('');

  // Summary
  console.log('='.repeat(50));
  console.log('🎉 Database Setup Test Complete!');
  console.log('='.repeat(50));
  console.log('\nNext steps:');
  console.log('1. If all tests passed, your database is ready');
  console.log('2. You can now implement the dashboard features');
  console.log('3. Test file uploads to storage buckets');
  console.log('4. Create test projects and applications');
}

// Run the test
testDatabaseSetup().catch(error => {
  console.error('💥 Test failed with error:', error);
});
