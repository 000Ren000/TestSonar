﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// БазоваяФункциональность
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	// Конец БазоваяФункциональность
	
	// работа с пользователями
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();	
	
	// работа с файлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = 
		ХранилищеОбщихНастроек.Загрузить("НастройкиОткрытияФайлов", "СпрашиватьРежимРедактированияПриОткрытииФайла");
	Если СпрашиватьРежимРедактированияПриОткрытииФайла = Неопределено Тогда
		СпрашиватьРежимРедактированияПриОткрытииФайла = Истина;
		ХранилищеОбщихНастроек.Сохранить("НастройкиОткрытияФайлов", "СпрашиватьРежимРедактированияПриОткрытииФайла", СпрашиватьРежимРедактированияПриОткрытииФайла);
	КонецЕсли;
	
	ДействиеПоДвойномуЩелчкуМыши = ХранилищеОбщихНастроек.Загрузить("НастройкиОткрытияФайлов", "ДействиеПоДвойномуЩелчкуМыши");
	Если ДействиеПоДвойномуЩелчкуМыши = Неопределено Тогда
		ДействиеПоДвойномуЩелчкуМыши = Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл;
		ХранилищеОбщихНастроек.Сохранить("НастройкиОткрытияФайлов", "ДействиеПоДвойномуЩелчкуМыши", ДействиеПоДвойномуЩелчкуМыши);
	КонецЕсли;
	
	СпособСравненияВерсийФайлов = ХранилищеОбщихНастроек.Загрузить("НастройкиСравненияФайлов", "СпособСравненияВерсийФайлов");
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПоказыватьПодсказкиПриРедактированииФайлов");
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПоказыватьИнформациюЧтоФайлНеБылИзменен");
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы");
	Если ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = Неопределено Тогда 
		ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = Истина;
		ХранилищеОбщихНастроек.Сохранить("НастройкиПрограммы", "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", ПоказыватьЗанятыеФайлыПриЗавершенииРаботы);
	КонецЕсли;
	
	ПоказыватьКолонкуРазмер = ХранилищеОбщихНастроек.Загрузить("НастройкиПрограммы", "ПоказыватьКолонкуРазмер");
	Если ПоказыватьКолонкуРазмер = Неопределено Тогда
		ПоказыватьКолонкуРазмер = Ложь;
		ХранилищеОбщихНастроек.Сохранить("НастройкиПрограммы", "ПоказыватьКолонкуРазмер", ПоказыватьКолонкуРазмер);
	КонецЕсли;
	
	ПоказыватьПредупреждениеПриРегистрации = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "ПоказыватьПредупреждениеПриРегистрации");
	Если ПоказыватьПредупреждениеПриРегистрации = Неопределено Тогда 
		ПоказыватьПредупреждениеПриРегистрации = Истина;
		ХранилищеОбщихНастроек.Сохранить("НастройкиРаботыСДокументами", "ПоказыватьПредупреждениеПриРегистрации", ПоказыватьПредупреждениеПриРегистрации);
	КонецЕсли;
	
	Элементы.Группа8.Видимость = Пользователи.ЭтоПолноправныйПользователь(, Истина)
									И (Не ОбщегоНазначения.РазделениеВключено()
									Или Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных());
	
	// Заполнение документов по статистике
	ЗаполнятьПоСтатистике = ХранилищеОбщихНастроек.Загрузить(
		"НастройкиРаботыСДокументами", "ЗаполнятьРеквизитыДокументовПоСтатистике");
	Если ЗаполнятьПоСтатистике <> Неопределено Тогда
		ЗаполнятьРеквизитыДокументовПоСтатистике = ЗаполнятьПоСтатистике;
	Иначе
		ЗаполнятьРеквизитыДокументовПоСтатистике = Истина;
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиРаботыСДокументами", "ЗаполнятьРеквизитыДокументовПоСтатистике", Истина);
	КонецЕсли;
	
	// Печать
	ЗапрашиватьПодтверждение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов");
	Если ЗапрашиватьПодтверждение <> Неопределено Тогда
		ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов = ЗапрашиватьПодтверждение;
	Иначе
		ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов = Истина;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов", Истина);
	КонецЕсли;
	
	ДоступноВыключениеКонтроляОстатков = ПраваПользователяПовтИсп.РазрешитьОтключениеКонтроляТоваровОрганизацийНаВремяСеанса();
	
	Если ДоступноВыключениеКонтроляОстатков Тогда
		ОбновитьНадписьКнопкиВыключитьКонтрольОстатковТоваровОрганизаций(ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций);
	КонецЕсли;
	
	ДоступноВыключениеКонтроляРезервовТоваровПоЗаказам = ПраваПользователяПовтИсп.РазрешитьОтключениеКонтроляРезервовТоваровПоЗаказамНаВремяСеанса();
	
	Если ДоступноВыключениеКонтроляРезервовТоваровПоЗаказам Тогда
		ОбновитьНадписьКнопкиВыключитьКонтрольРезервовТоваровПоЗаказам(ПараметрыСеанса.ПроводитьБезКонтроляРезервовТоваровПоЗаказам);
	КонецЕсли;
	
	Элементы.ВыключитьКонтрольОстатковТоваров.Видимость = ДоступноВыключениеКонтроляОстатков;
	Элементы.ВыключитьКонтрольРезервовТоваровПоЗаказам.Видимость = ДоступноВыключениеКонтроляРезервовТоваровПоЗаказам;
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		Элементы.ИнтеграцияС1СДокументооборот.Видимость = Ложь;
	КонецЕсли;
	
	// Учет зарплаты и кадров
	Элементы.УчетЗарплатыИКадров.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ");
	Элементы.ОчиститьНастройкиПодписанияЭЦПКадровогоЭДО.Видимость =
		ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПодсистемы.КадровыйЭДО");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапрашиватьПодтверждениеПриЗавершенииПрограммыПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
		
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьИОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	МассивСтруктур = Новый Массив;
	
	// работа с файлами
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиОткрытияФайлов");
	Элемент.Вставить("Настройка", "ДействиеПоДвойномуЩелчкуМыши");
	Элемент.Вставить("Значение", ДействиеПоДвойномуЩелчкуМыши);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиОткрытияФайлов");
	Элемент.Вставить("Настройка", "СпрашиватьРежимРедактированияПриОткрытииФайла");
	Элемент.Вставить("Значение", СпрашиватьРежимРедактированияПриОткрытииФайла);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПрограммы");
	Элемент.Вставить("Настройка", "ПоказыватьПодсказкиПриРедактированииФайлов");
	Элемент.Вставить("Значение", ПоказыватьПодсказкиПриРедактированииФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПрограммы");
	Элемент.Вставить("Настройка", "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы");
	Элемент.Вставить("Значение", ПоказыватьЗанятыеФайлыПриЗавершенииРаботы);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСравненияФайлов");
	Элемент.Вставить("Настройка", "СпособСравненияВерсийФайлов");
	Элемент.Вставить("Значение", СпособСравненияВерсийФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПрограммы");
	Элемент.Вставить("Настройка", "ПоказыватьКолонкуРазмер");
	Элемент.Вставить("Значение", ПоказыватьКолонкуРазмер);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиРаботыСДокументами");
	Элемент.Вставить("Настройка", "ЗаполнятьРеквизитыДокументовПоСтатистике");
	Элемент.Вставить("Значение", ЗаполнятьРеквизитыДокументовПоСтатистике);
	МассивСтруктур.Добавить(Элемент);
	
	// БазоваяФункциональность
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "ОбщиеНастройкиПользователя",
	    "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
	    ЗапрашиватьПодтверждениеПриЗавершенииПрограммы));
	// Конец БазоваяФункциональность
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьИнформациюЧтоФайлНеБылИзменен",
	    ПоказыватьИнформациюЧтоФайлНеБылИзменен));
	
	// Печать
	МассивСтруктур.Добавить(ОписаниеНастройки(
		"ОбщиеНастройкиПользователя",
		"ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов",
		ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов));
	// Конец Печать
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	Модифицированность = Ложь;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкаРабочегоКаталога",,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	НачатьУстановкуРасширенияРаботыСФайлами(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(Неопределено, ТекущийПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСистемы(Команда)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета");
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",
	                  Новый Структура("НастройкаПроксиНаКлиенте", Истина));
					  
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭЦП(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСКриптографиейНаКлиенте(Команда)
	НачатьУстановкуРасширенияРаботыСКриптографией(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыАвторизацииВ1СДокументооборот(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот",,,,,,
		Неопределено,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ВыключитьКонтрольОстатковТоваров(Команда)
	ВыключитьКонтрольОстатковТоваровСервер();
КонецПроцедуры

&НаКлиенте
Процедура ВыключитьКонтрольРезервовТоваровПоЗаказам(Команда)
	
	ВыключитьКонтрольРезервовТоваровПоЗаказамСервер();
	
КонецПроцедуры

&НаСервере
Процедура ВыключитьКонтрольОстатковТоваровСервер()
	ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций = Не ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций;
	
	ОбновитьНадписьКнопкиВыключитьКонтрольОстатковТоваровОрганизаций(ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций);
	
	Если ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций Тогда
		ТекстСообщения = НСтр("ru = 'Пользователем %ИмяПользователя% в рамках своего сеанса выключен контроль остатков товаров организаций.'", Метаданные.ОсновнойЯзык.КодЯзыка);
	Иначе
		ТекстСообщения = НСтр("ru = 'Пользователем %ИмяПользователя% возобновлен контроль остатков товаров организаций.'", Метаданные.ОсновнойЯзык.КодЯзыка);
	КонецЕсли;
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяПользователя%", Пользователи.ТекущийПользователь());
	
	ЗаписьЖурналаРегистрации(ЗапасыСервер.ИмяСобытияВыключенКонтрольОстатков(),
		УровеньЖурналаРегистрации.Предупреждение, , ,ТекстСообщения);
КонецПроцедуры

&НаКлиенте
Процедура СпрашиватьРежимРедактированияПриОткрытииФайлаПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПодсказкиПриРедактированииФайловПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗанятыеФайлыПриЗавершенииРаботыПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьКолонкуРазмерПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИнформациюЧтоФайлНеБылИзмененПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура СпособСравненияВерсийФайловПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументовПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНастройкиПодписанияЭЦПКадровогоЭДО(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПодсистемы.КадровыйЭДО") Тогда
		МодульКадровыйЭДОКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КадровыйЭДОКлиент");
		МодульКадровыйЭДОКлиент.ОчиститьНастройкиПодписанияПечатныхФорм();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИОбновитьИнтерфейсПрограммы()
	ЗаписатьИЗакрыть();
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПоДвойномуЩелчкуМышиПриИзменении(Элемент)
	ЗаписатьИОбновитьИнтерфейсПрограммы();
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Неопределен) Экспорт
	ЗаписатьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Функция ОписаниеНастройки(Объект, Настройка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настройка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура ОбновитьНадписьКнопкиВыключитьКонтрольОстатковТоваровОрганизаций(КонтрольВыключен)
	Если КонтрольВыключен Тогда
		Элементы.ВыключитьКонтрольОстатковТоваров.Заголовок = НСтр("ru = 'Возобновить контроль остатков'");
		Элементы.ВыключитьКонтрольОстатковТоваров.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Восстановление контроля остатков товаров организаций для текущего пользователя, ранее выключенных на время сеанса.'");
	Иначе
		Элементы.ВыключитьКонтрольОстатковТоваров.Заголовок = НСтр("ru = 'Отключить контроль остатков (на время сеанса)'");
		Элементы.ВыключитьКонтрольОстатковТоваров.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Выключение контроля остатков товаров организаций для текущего пользователя на время сеанса работы.'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыключитьКонтрольРезервовТоваровПоЗаказамСервер()
	
	ПараметрыСеанса.ПроводитьБезКонтроляРезервовТоваровПоЗаказам = Не ПараметрыСеанса.ПроводитьБезКонтроляРезервовТоваровПоЗаказам;
	
	ОбновитьНадписьКнопкиВыключитьКонтрольРезервовТоваровПоЗаказам(ПараметрыСеанса.ПроводитьБезКонтроляРезервовТоваровПоЗаказам);
	
	Если ПараметрыСеанса.ПроводитьБезКонтроляРезервовТоваровПоЗаказам Тогда
		ТекстСообщения = НСтр("ru = 'Пользователем %ИмяПользователя% в рамках своего сеанса выключен контроль резервов по заказам.'",
			ОбщегоНазначения.КодОсновногоЯзыка());
	Иначе
		ТекстСообщения = НСтр("ru = 'Пользователем %ИмяПользователя% возобновлен контроль резервов по заказам.'",
			ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяПользователя%", Пользователи.ТекущийПользователь());
	
	ЗаписьЖурналаРегистрации(ОбеспечениеВДокументахСервер.ИмяСобытияВыключенКонтрольРезервовТоваровПоЗаказам(),
		УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьКнопкиВыключитьКонтрольРезервовТоваровПоЗаказам(КонтрольВыключен)
	
	Если КонтрольВыключен Тогда
		Элементы.ВыключитьКонтрольРезервовТоваровПоЗаказам.Заголовок = НСтр("ru = 'Возобновить контроль резервов'");
		Элементы.ВыключитьКонтрольРезервовТоваровПоЗаказам.РасширеннаяПодсказка.Заголовок
			= НСтр("ru = 'Восстановление контроля резервов товаров по заказам для текущего пользователя, ранее выключенных на время сеанса.'");
	Иначе
		Элементы.ВыключитьКонтрольРезервовТоваровПоЗаказам.Заголовок = НСтр("ru = 'Отключить контроль резервов (на время сеанса)'");
		Элементы.ВыключитьКонтрольРезервовТоваровПоЗаказам.РасширеннаяПодсказка.Заголовок
			= НСтр("ru = 'Выключение контроля резервов товаров по заказам для текущего пользователя на время сеанса работы.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
